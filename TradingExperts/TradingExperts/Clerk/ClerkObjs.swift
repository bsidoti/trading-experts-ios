//
//  ClerkObjs.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 5/23/21.
//  Copyright © 2021 Braden Sidoti. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Client: Codable {
    let JWT: String
    let id: String
    let session: Session?
    
    init?(JWT: String, clientJSON: JSON) {
        guard let id = clientJSON["id"].string else {
            return nil
        }
        self.id = id
        self.JWT = JWT
        
        let firstSessionJSON = (clientJSON["sessions"].array?.count ?? -1) > 0 ? clientJSON["sessions"].array![0] : nil
        if let sessionJSON = firstSessionJSON {
            self.session = Session(sessionJSON)
        } else {
            self.session = nil
        }
    }
}

struct Session: Codable {
    let id: String
    let status: String
    let user: User

    init?(_ sessionJSON: JSON) {
        guard let id = sessionJSON["id"].string,
              let status = sessionJSON["status"].string,
              let user = User(sessionJSON["user"])
        else {
            return nil
        }
        self.status = status
        self.id = id
        self.user = user
    }
}

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let primaryEmailAddress: String
    let profileImageURLString: String
    let isAlpha: Bool

    var profileImageURL: URL {
        get {
            return URL(string: profileImageURLString)!
        }
    }
    
    init?(_ userJSON: JSON) {
        guard let id = userJSON["id"].string,
              let firstName = userJSON["first_name"].string,
              let lastName = userJSON["last_name"].string,
              let profileImageURLString = userJSON["profile_image_url"].string,
              let primaryEmailAddressID = userJSON["primary_email_address_id"].string,
              let emailAddress = userJSON["email_addresses"].array?[0],
              let emailAddressID = emailAddress["id"].string,
              emailAddressID == primaryEmailAddressID,
              let primaryEmailAddress = emailAddress["email_address"].string
        else {
            return nil
        }

        if let memType = userJSON["public_metadata"]["membership"].string, memType == "Alpha" {
            isAlpha = true
        } else {
            isAlpha = false
        }
        
        
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageURLString = profileImageURLString
        self.primaryEmailAddress = primaryEmailAddress
    }
}
