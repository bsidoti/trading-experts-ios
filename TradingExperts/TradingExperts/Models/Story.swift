//
//  Story.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/24/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

enum Story: String {
    case apple_flash_crash
    case are_penny_stocks_for_losers
    case baba_ipo
    case dumb_money
    case get_out
    case get_to_zee_chopper
    case i_can_teach_myself
    case my_first_ipo_twitter
    case perspective
    case shouldve_let_em_steal_it
    case sure_well_take_the_limo
    case thats_impossible
    case the_bidu_massacre
    case the_og_book
    case wheres_this_gonna_open
    case who_needs_a_game_plan
    case why_the_fuck_are_you_here
    
    static func all() -> [Story] {
        return [.apple_flash_crash,
        .are_penny_stocks_for_losers,
        .baba_ipo,
        .dumb_money,
        .get_out,
        .get_to_zee_chopper,
        .i_can_teach_myself,
        .my_first_ipo_twitter,
        .perspective,
        .shouldve_let_em_steal_it,
        .sure_well_take_the_limo,
        .thats_impossible,
        .the_bidu_massacre,
        .the_og_book,
        .wheres_this_gonna_open,
        .who_needs_a_game_plan,
        .why_the_fuck_are_you_here]
    }
    
    func title() -> String {
        switch self {
        case .apple_flash_crash:
            return "Apple Flash Crash"
        case .are_penny_stocks_for_losers:
            return "Are Penny Stocks for Losers?"
        case .baba_ipo:
            return "BABA IPO: The Craziest Hour of My Life"
        case .dumb_money:
            return "Dumb Money"
        case .get_out:
            return "Get Out"
        case .get_to_zee_chopper:
            return "Get to Zee Chopper"
        case .i_can_teach_myself:
            return "I Can Teach Myself"
        case .my_first_ipo_twitter:
            return "Twitter: My First IPO"
        case .perspective:
            return "Perspective"
        case .shouldve_let_em_steal_it:
            return "Should've Let Them Steal It"
        case .sure_well_take_the_limo:
            return "Breakfast? Let's Take The Limo"
        case .thats_impossible:
            return "That's Impossible"
        case .the_bidu_massacre:
            return "BIDU Massacre"
        case .the_og_book:
            return "The OG Book"
        case .wheres_this_gonna_open:
            return "Where the f*ck is this going to open?!"
        case .who_needs_a_game_plan:
            return "A $60,000 loss"
        case .why_the_fuck_are_you_here:
            return "Why the f*ck are you here?"
        }
    }
    
    func coverImage() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
    
}

extension Story: ImageCollectionViewCellData {
    var image: UIImage? {
        return coverImage()
    }
    
    var imageUrlString: String? {
        return nil
    }
    
    var isMemberOnly: Bool {
        return false
    }
}

extension Story: PdfData {
    var pdfUrl: URL {
        return Bundle.main.url(forResource: self.rawValue, withExtension: "pdf")!
    }
}
