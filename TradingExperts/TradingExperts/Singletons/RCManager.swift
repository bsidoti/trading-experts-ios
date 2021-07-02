//
//  RevenueCatManager.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 1/14/19.
//  Copyright © 2019 Braden Sidoti. All rights reserved.
//
/*
import Foundation
import Purchases

protocol RCRestoreDelegate: AnyObject {
    func restoreCompleted()
    func restoreFailed(error: Error)
}

protocol RCPurchaseDelegate: AnyObject {
    func purhcaseCompleted()
    func purhcaseFailed(error: Error)
}

class RCManager: NSObject {
    static let shared = RCManager()
    static let currentEntitlementsUserDefaultsKey = "currentEntitlementsUserDefaultsKey"
    
    weak var purchaseDelegate: RCPurchaseDelegate?
    weak var restoreDelegate: RCRestoreDelegate?
    
//    var currentSubscriptions: Set<String> {
//        get {
//            return Set<String>()
//            for stri
//            return UserDefaults.standard.stringArray(forKey: RCManager.currentEntitlementsUserDefaultsKey) ?? []
//            return UserDefaults.standard.stringArray(forKey: RCManager.currentEntitlementsUserDefaultsKey) ?? []
//        }
//
//        set(newSubscriptions) {
//            currentSubscriptions = newSubscriptions
//        }
//    }
    
    var currentEntitlements: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: RCManager.currentEntitlementsUserDefaultsKey) ?? []
        }
        
        set(newEntitlements) {
            UserDefaults.standard.set(newEntitlements, forKey: RCManager.currentEntitlementsUserDefaultsKey)
        }
    }
    
    var membershipName: String {
        var finalString = ""
        
        for (i, ent) in currentEntitlements.enumerated() {
            switch ent {
            case "all_access":
                finalString.append(contentsOf: "All Access")
            case "membership_access":
                finalString.append(contentsOf: "Membership Access")
            case "alpha_alerts":
                finalString.append(contentsOf: "Alpha Alerts")

            default:
                finalString.append(contentsOf: ent)
            }
            
            if i != currentEntitlements.count - 1 {
                finalString.append(contentsOf: ",")
            }
        }
        
        return finalString
    }
}

extension RCManager: PurchasesDelegate {
    // update purhcaser info
    func purchases(_ purchases: Purchases, receivedUpdatedPurchaserInfo purchaserInfo: Purchases.PurchaserInfo) {
//        print("receivedUpdatedPurchaserInfo: \(purchaserInfo.entitlements)")
//        currentEntitlements = purchaserInfo.entitlements.active
    }
    
    func purchases(_ purchases: Purchases, failedToUpdatePurchaserInfoWithError error: Error) {
        print("failedToUpdatePurchaserInfoWithError: \(error)")
    }
    
    
    // restore transaction
    func purchases(_ purchases: Purchases, failedToRestoreTransactionsWithError error: Error) {
        print("failed restore: \(error)")
        restoreDelegate?.restoreFailed(error: error)
    }
    
    func purchases(_ purchases: Purchases, restoredTransactionsWith purchaserInfo: Purchases.PurchaserInfo) {
//        print("completed restore: \(purchaserInfo.activeEntitlements)")
//        currentEntitlements = Array(purchaserInfo.activeEntitlements)
        restoreDelegate?.restoreCompleted()
    }
    
    
    // purchase transaction
    func purchases(_ purchases: Purchases, completedTransaction transaction: SKPaymentTransaction, withUpdatedInfo purchaserInfo: Purchases.PurchaserInfo) {
        print("purchases:completedTransaction:withUpdatedInfo")
        print(purchaserInfo.activeSubscriptions)
//        purchaserInfo.activeSubscriptions
//        print("completed purchase: \(purchaserInfo.activeEntitlements)")
//        currentEntitlements = Array(purchaserInfo.activeEntitlements)
//        purchaseDelegate?.purhcaseCompleted()
    }
    
    func purchases(_ purchases: Purchases, failedTransaction transaction: SKPaymentTransaction, withReason failureReason: Error) {
        print("failed purchase: \(failureReason)")
        purchaseDelegate?.purhcaseFailed(error: failureReason)
    }

    
    
    private func purchases(_ purchases: Purchases, shouldPurchasePromoProduct product: SKProduct, defermentBlock makeDeferredPurchase: @escaping RCDeferredPromotionalPurchaseBlock) -> Bool {
        return true
    }
}
*/
