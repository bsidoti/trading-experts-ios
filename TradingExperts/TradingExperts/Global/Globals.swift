//
//  PushHelper.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/22/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import UIKit

private let uuidUserDefaultsKey = "uuidUserDefaultsKey"
func uuid() -> String {
    if let uuid = UserDefaults.standard.string(forKey: uuidUserDefaultsKey) {
        return uuid
    } else {
        let uuid = NSUUID().uuidString
        UserDefaults.standard.setValue(uuid, forKey: uuidUserDefaultsKey)
        return uuid
    }
}

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

struct TEFormatters {
    static var currency: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }

    static var dateShortHand: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }
}

