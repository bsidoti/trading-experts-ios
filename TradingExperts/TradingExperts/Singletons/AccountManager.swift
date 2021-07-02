//
//  AccountManager.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/11/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import SwiftyJSON

//struct Account: Codable {
//    let email: String
//    let password: String
//    let id: String
//    var authHeader: String
//    let firstName: String?
//    let lastName: String?
//    let profileImageURL: String?
//    var memberType: String?
//
//
//    init?(email: String, password: String, authHeader: String, userJSONData: JSON) {
////        do {
//            self.email = email
//            self.password = password
//            self.authHeader = authHeader
//
//            guard let id = userJSONData["id"].string else {
//                return nil
//            }
//
//            self.id = id
//            self.firstName = userJSONData["first_name"].string
//            self.lastName = userJSONData["last_name"].string
//            self.profileImageURL = userJSONData["profile_image_url"].string
//            self.memberType = userJSONData["public_metadata"]["member_type"].string
////        } catch {
////            return nil
////        }
//    }
//}


class AccountManager {
    static let sharedInstance = AccountManager()
    
    static func isLoggedIn() -> Bool {
        guard let currSession = Clerk.shared.currentClient?.session, currSession.status == "active" else {
            return false
        }

        return true
    }
    
    static func isMember() -> Bool {
        guard let currSession = Clerk.shared.currentClient?.session, currSession.status == "active" else {
            return false
        }
        
        return currSession.user.isAlpha
    }
}
