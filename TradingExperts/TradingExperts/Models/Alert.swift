//
//  Alert.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/25/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation

struct Alert: Codable {
    let id: Int
    let title: String
    let body: String
    let imageUrl: String
    let createdAt: UInt64
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
    
    func getCreatedAtDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(createdAt))
    }
}
