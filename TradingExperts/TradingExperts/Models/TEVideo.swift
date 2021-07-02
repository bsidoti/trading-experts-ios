//
//  TEVideo.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/19/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

typealias TEVideo = VideoResponse.TEVideo

struct VideoResponse: Decodable {
    let nextPageToken: String?
    let items: [TEVideo]
    
    struct TEVideo: Decodable {
        let id: String
        let position: Int
        let title: String
        let description: String
        let imageUrl: String?
        let publishedAt: Date
        
        
        enum CodingKeys: String, CodingKey {
            // containers
            case snippet
            case resourceId
            case thumbnails
            
            // different image types, just grab the biggest
            case `default`
            case medium
            case high
            case standard
            case maxres
            
            // actual data
            case id = "videoId"
            case position
            case title
            case description
            case imageUrl = "url"
            case publishedAt
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let snippet = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
            publishedAt = try snippet.decode(Date.self, forKey: .publishedAt)
            title = try snippet.decode(String.self, forKey: .title)
            description = try snippet.decode(String.self, forKey: .description)
            position = try snippet.decode(Int.self, forKey: .position)
            
            
            let thumbnails = try snippet.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
            
            
            if let maxres = try? thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .maxres) {
                imageUrl = try maxres.decode(String.self, forKey: .imageUrl)
            } else if let standard = try? thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .standard) {
                imageUrl = try standard.decode(String.self, forKey: .imageUrl)
            } else if let high = try? thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .high) {
                imageUrl = try high.decode(String.self, forKey: .imageUrl)
            } else if let medium = try? thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .medium) {
                imageUrl = try medium.decode(String.self, forKey: .imageUrl)
            } else if let `default` = try? thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .default) {
                imageUrl = try `default`.decode(String.self, forKey: .imageUrl)
            } else {
                imageUrl = nil
            }
                                
            let resourceId = try snippet.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
            id = try resourceId.decode(String.self, forKey: .id)
        }
    }
}

extension TEVideo: ImageCollectionViewCellData {
    var image: UIImage? {
        return nil
    }
    
    var imageUrlString: String? {
        return imageUrl
    }
    
    var isMemberOnly: Bool {
        return false
    }
}
