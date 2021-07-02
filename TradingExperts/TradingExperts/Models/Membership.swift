//
//  Membership.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 12/18/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit


struct Membership {
    struct Plan {
        let period: String
        let price: Decimal
        let rcOfferingName: String
        
        var title: String {
            let priceString = TEFormatters.currency.string(from: NSDecimalNumber(decimal: price))!
            return "\(priceString) per \(period)"
        }
    }
    
    static let allAccess = """
        Benefits you receive
        - Personal Mentoring from the Trading Experts
        - Access to our Alpha Alerts on this app with instant notifications
        - Access to our Members ALPHA Group Chat
        - Weekly Shake Down Newsletter in your inbox every weekend with the top swing trading ideas for the week ahead!
        - Weekly Big Picture Newsletter in your inbox every weekend covering all the major markets for the week ahead!
        """

    static let memAccess = """
        Benefits you receive
        - Access to our Alpha Alerts on this app with instant notifications
        - Access to our Members Group Chat
        - Weekly Shake Down Newsletter in your inbox every weekend with the top swing trading ideas for the week ahead!
        - Weekly Big Picture Newsletter in your inbox every weekend covering all the major markets for the week ahead!
        """

    static let alpha = """
        Benefits you receive
        - Access to our Alpha Alerts on this app with instant notifications
        - Access to our Alpha Alerts Group Chat
        - Weekly Shake Down Newsletter in your inbox every weekend with the top swing trading ideas for the week ahead!
        - Weekly Big Picture Newsletter in your inbox every weekend covering all the major markets for the week ahead!
        """

    let image: UIImage
    let title: String
    let rcEntitlementName: String
    let promoText: [String]
    let plan: Plan
    
    static func all() -> [Membership] {
        let allAccess = Membership(image: UIImage(named: "all_access")!, title: "All Access Membership", rcEntitlementName: "all_access", promoText: [Membership.allAccess], plan: Plan(period: "Month", price: Decimal(string: "329.99")!, rcOfferingName: "monthly"))
        
        let membershipAccess = Membership(image: UIImage(named: "membership_access")!, title: "Membership Access", rcEntitlementName: "membership_access", promoText: [Membership.memAccess], plan: Plan(period: "Month", price: Decimal(string: "264.99")!, rcOfferingName: "monthly"))

        let alphaAlerts = Membership(image: UIImage(named: "alpha_alerts")!, title: "Alpha Alerts Membership", rcEntitlementName: "alpha_alerts", promoText: [Membership.alpha], plan: Plan(period: "Month", price: Decimal(string: "149.99")!, rcOfferingName: "monthly"))
        
        return [allAccess, membershipAccess, alphaAlerts]
    }
    
    static func titleForPlan(_ plan: (period: String, price: Decimal, planId: String)) -> String {
        let priceString = TEFormatters.currency.string(from: NSDecimalNumber(decimal: plan.price))!
        return "\(priceString) per \(plan.period)"
    }
}

