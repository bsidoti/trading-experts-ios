//
//  TEFont.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 12/15/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

struct TEFont {
    
    struct Barlow {
        enum Weight: String {
            case black
            case bold
            case regular
            case semiBold
            case extraLight
        }
    }
    
    static func barlow(weight: Barlow.Weight, size: CGFloat) -> UIFont {
        let uppercasedWeight = weight.rawValue.prefix(1).uppercased() + weight.rawValue.dropFirst()
        return UIFont(name: "Barlow-\(uppercasedWeight)", size: size)!
    }
}
