//
//  TEGlobalStyles.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 12/15/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit


class GlobalStyle {
    static func apply() {
        let attributes =
            [NSAttributedString.Key.font: TEFont.barlow(weight: .bold, size: 20) as Any,
             NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().barTintColor = UIColor.te_darkGray
        
        UITabBar.appearance().backgroundColor = UIColor.te_darkGray
        UITabBar.appearance().tintColor = UIColor.te_green
    }
}
