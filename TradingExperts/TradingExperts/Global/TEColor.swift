//
//  TEColor.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/26/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

extension UIColor {
    static let te_extraLightGray = UIColor(numericRGB: 240)
    static let te_lightGray = UIColor.white //UIColor(numericRGB: 200)
    static let te_blue = UIColor(numericRed: 119, green: 150, blue: 168)
    static let te_green = UIColor(numericRed: 20, green: 173, blue: 97)
    static let te_darkGray = UIColor(numericRed: 61, green: 66, blue: 70)
    
//    #3d4246
}


extension UIColor {
    convenience init(numericRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    convenience init(numericRGB rgb: CGFloat, alpha: CGFloat = 1) {
        self.init(red: rgb / 255, green: rgb / 255, blue: rgb / 255, alpha: alpha)
    }
}
