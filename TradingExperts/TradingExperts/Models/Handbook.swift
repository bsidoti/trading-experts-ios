//
//  Handbook.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/21/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

enum Handbook: String {
    case chartReading
    case dumbMoney
    case gamePlanning
    case gettingStarted
    case secret
    case swingingWithSharks
    case takingProfits
    case tradingPsychology
    case whatsNext
    case tradeTheory
    
    func title() -> String {
        switch self {
        case .chartReading:
            return "Chart Reading"
        case .dumbMoney:
            return "Dumb Money"
        case .gamePlanning:
            return "Game Planning"
        case .gettingStarted:
            return "Getting Started"
        case .secret:
            return "The Secret"
        case .swingingWithSharks:
            return "Swinging With Sharks"
        case .takingProfits:
            return "Taking Profits"
        case .tradingPsychology:
            return "Trading Psychology"
        case .whatsNext:
            return "What's Next"
        case .tradeTheory:
            return "Trade Theory"
        }
    }
    
    static func all() -> [Handbook] {
        return [.gettingStarted,
                .whatsNext,
                .dumbMoney,
                .gamePlanning,
                .chartReading,
                .tradingPsychology,
                .takingProfits,
                .swingingWithSharks,
                .secret,
                .tradeTheory,
                ]
    }
    
    func coverImage() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

extension Handbook: ImageCollectionViewCellData {
    var image: UIImage? {
        return coverImage()
    }
    

    var imageUrlString: String? {
        return nil
    }
    
    var isMemberOnly: Bool {
        if self == .gettingStarted || self == .whatsNext || self == .dumbMoney {
            return false
        } else {
            return true
        }
    }
}

extension Handbook: PdfData {
    var pdfUrl: URL {
        return Bundle.main.url(forResource: self.rawValue, withExtension: "pdf")!
    }
}
