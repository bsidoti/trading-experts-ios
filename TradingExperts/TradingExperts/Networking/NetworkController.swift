//
//  NetworkController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/25/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ParsingError: Error {
    case generic
}

enum NetworkingError: Error {
    case generic
    case unauthorized
    case unauthenticated
    case message(String)
    
    func message() -> String {
        switch self {
        case .generic:
            return "generic"
        case .unauthorized:
            return "unauthorized"
        case .unauthenticated:
            return "unauthenticated"
        case .message(let str):
            return str
        }
    }
}

extension DateFormatter {
    static let railsDefault: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}

class NetworkController: NSObject {
    static var shared: NetworkController!
    let baseAPIUrl: String
    let clerkObj: Clerk
    
    init(baseAPIUrl: String, clerkObj: Clerk) {
        self.clerkObj = clerkObj
        self.baseAPIUrl = baseAPIUrl
    }
    
    // MARK: - posts
    func postDevice(apnsToken: String, completion: @escaping (Error?) -> ()) {
        guard let currentClient = Clerk.shared.currentClient else {
            completion(NetworkingError.unauthorized)
            return
        }
        
        let parameters: Parameters = [
            "apns_token": apnsToken
        ]
        
        let headers = ["Authorization": currentClient.JWT]
        
        AF.request("\(baseAPIUrl)/users/add_device", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).response { (data) in
            guard let response = data.response else {
                completion(NetworkingError.generic)
                return
            }
            if response.statusCode != 200 {
                completion(NetworkingError.generic)
                return
            }
            
                completion(nil)
        }
    }
    
    
    // MARK: - get functions
    func getAlerts(completion: @escaping (Result<[Alert]>) -> ()) {
        guard let currentClient = Clerk.shared.currentClient else {
            completion(Result.failure(NetworkingError.unauthorized))
            return
        }

        let headers = ["Authorization": currentClient.JWT]
        
        
        AF.request("\(baseAPIUrl)/alerts", headers: HTTPHeaders(headers)).response { (dataResponse) in
            guard let data = dataResponse.data, let statusCode = dataResponse.response?.statusCode, statusCode == 200 else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()                
                let alerts = try decoder.decode([Alert].self, from: data)
                completion(Result.success(alerts))
            } catch {
                completion(Result.failure(ParsingError.generic))
            }
        }
    }
    
    func getAllVideos(completion: @escaping (Result<[TEVideo]>) -> ()) {
        var allVideos = [TEVideo]()
        
        func rec_getAllVideos(pageToken: String) {
            getVideos(pageToken: pageToken) { (result) in
                switch result {
                case .success(let videoResponse):
                    allVideos.append(contentsOf: videoResponse.items)
                    
                    if let pageToken = videoResponse.nextPageToken {
                        rec_getAllVideos(pageToken: pageToken)
                    } else {
                        completion(Result.success(allVideos))
                    }
                    
                case .failure:
                    completion(Result.success(allVideos))
                }
            }
        }
        
        // only fail if first request fails, otherwise recursively go until we find no nextPage.
        getVideos(pageToken: nil) { (result) in
            switch result {
            case .success(let videoResponse):
                allVideos.append(contentsOf: videoResponse.items)
                
                if let pageToken = videoResponse.nextPageToken {
                    rec_getAllVideos(pageToken: pageToken)
                } else {
                    completion(Result.success(allVideos))
                }
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        
    }
    
    func getVideos(pageToken: String?, completion: @escaping (Result<VideoResponse>) -> ()) {
        let tePlaylistId = "UUDCmo0byYknxySJlB2suWCA"
        let apiKey = "AIzaSyCMkoW-A9ciNxu1x-ZheiMr0s9u_7bkj9k"
        var params: [String: Any] = ["part": "snippet",
                                     "maxResults": 50,
                                     "playlistId": tePlaylistId,
                                     "key": apiKey]
        
        if let pageToken = pageToken {
            params["pageToken"] = pageToken
        }
        
        
        AF.request("https://www.googleapis.com/youtube/v3/playlistItems", method: .get, parameters: params, encoding: URLEncoding.queryString, headers: nil).response { (dataResponse) in
            guard let data = dataResponse.data else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            do {
                print(String(data: data, encoding: .utf8)!)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.railsDefault)
                
                let videoResponse = try decoder.decode(VideoResponse.self, from: data)
                completion(Result.success(videoResponse))
            } catch {
                completion(Result.failure(error))
            }
        }
    }
    
    
    // MARK: - Clerk Endpoints
    /*
    static func authenticate(email: String, password: String, completion: @escaping (Result<Account>) -> ()) {
        let parameters = [ "identifier": email, "password": password ]
        let headers: HTTPHeaders = ["Authorization": ""]

        AF.request("\(clerkURL)/v1/client/sign_in_attempt", method: .put, parameters: parameters, headers: headers).response { (dataResponse) in
            
            guard let data = dataResponse.data else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            guard let response = dataResponse.response else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            if response.statusCode != 200 {
                if response.statusCode == 401 {
                    completion(Result.failure(NetworkingError.unauthorized))
                    return
                }

                guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                      let errorsArr = json["errors"] as? [[String: Any]],
                      let errorMessage = errorsArr[0]["message"] as? String
                else {
                    completion(Result.failure(NetworkingError.generic))
                    return
                }
                
                completion(Result.failure(NetworkingError.message(errorMessage)))
                return
            }
            
            guard let authHeader = response.allHeaderFields["Authorization"] as? String else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            guard let json = try? JSON(data: data) else {
                completion(Result.failure(NetworkingError.generic))
                return
            }
            
            let userJSON = json["client"]["sessions"][0]["user"]
                
            if let account = Account(email: email, password: password, authHeader: authHeader, userJSONData: userJSON) {
                completion(Result.success(account))
            } else {
                completion(Result.failure(ParsingError.generic))
            }
        }
    }*/
}
