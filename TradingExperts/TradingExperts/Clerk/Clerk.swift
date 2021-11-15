//
//  CKLoginManager.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 5/23/21.
//  Copyright © 2021 Braden Sidoti. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Clerk {
    // must be initialized before using, usually at the top of `AppDelegate#application:didFinishLaunchingWithOptions:`
    static var shared: Clerk!
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    private static let currentClientUserDefaultsKey = "currentClientUserDefaultsKey"
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    
    let frontendAPIDomain: String
    let frontendAPIURL: String
    let signInURL: String
    let afterSignInURL: String

    // MARK: - init
    init(frontendAPIDomain: String, signInURL: String, afterSignInURL: String) {
        self.frontendAPIDomain = frontendAPIDomain
        self.frontendAPIURL = "https://\(frontendAPIDomain)"
        self.signInURL = signInURL
        self.afterSignInURL = afterSignInURL
    }
    
    // MARK: - current client
    private var _currentClient: Client?
    var currentClient: Client? {
        get {
            if _currentClient != nil {
                return _currentClient
            }
            
            guard let data = UserDefaults.standard.data(forKey: Clerk.currentClientUserDefaultsKey) else {
                return nil
            }
            
            
            guard let storedClient = try? Clerk.decoder.decode(Client.self, from: data)  else {
                return nil
            }
                        
            _currentClient = storedClient
            return _currentClient
        }
        
        set(newClient) {
            if newClient == nil {
                _currentClient = nil
                UserDefaults.standard.removeObject(forKey: Clerk.currentClientUserDefaultsKey)
                return
            }
            
            
            if let data = try? Clerk.encoder.encode(newClient) {
                UserDefaults.standard.set(data, forKey: Clerk.currentClientUserDefaultsKey)
                _currentClient = newClient
            }
        }
    }

    // MARK: - network requests
    func getClient(clientJWT: String, completion: @escaping (Result<Client>) -> ()) {
        AF.request("\(frontendAPIURL)/v1/client?_is_native=true", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": clientJWT]).response { (inData) in
            guard let response = inData.response, let data = inData.data else {
                self.currentClient = nil
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            if response.statusCode != 200 {
                self.currentClient = nil
                completion(Result.failure(NetworkingError.generic))
                return
            }

            guard let clientJSON = try? JSON(data: data) else {
                self.currentClient = nil
                completion(Result.failure(NetworkingError.generic))
                return
            }

            guard let client = Client(JWT: clientJWT, clientJSON: clientJSON["response"]) else {
                self.currentClient = nil
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            self.currentClient = client
            
            completion(Result.success(client))
        }
    }
    
    // MARK: - network requests
    func endSession(completion: @escaping (Error?) -> ()) {
        guard let currentSession = self.currentClient?.session,
              let clientJWT = self.currentClient?.JWT
        else {
            // not logged in
            completion(nil)
            return
        }
        
        
        AF.request("\(frontendAPIURL)/v1/client/sessions/\(currentSession.id)/end?_is_native=true", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": clientJWT]).response { (inData) in
            // regardless of the response, log the user out.
            self.currentClient = nil
            completion(nil)

            guard let response = inData.response else {
                completion(NetworkingError.generic)
                return
            }
            
            if response.statusCode != 200 {
                completion(NetworkingError.generic)
                return
            }
        }
    }
}
