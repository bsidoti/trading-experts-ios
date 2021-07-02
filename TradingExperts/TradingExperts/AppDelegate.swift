//
//  AppDelegate.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 12/15/17.
//  Copyright © 2017 Braden Sidoti. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Clerk.shared = Clerk(
            frontendAPIDomain: "clerk.tradingexperts.app",
            signInURL: "https://accounts.tradingexperts.app/sign-in",
            afterSignInURL: "https://www.tradingexperts.app/"
        )
        
        NetworkController.shared = NetworkController(
            baseAPIUrl: "https://api.tradingexperts.app",
            clerkObj: Clerk.shared
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window!.rootViewController = MainTabBarController.storyboardInit()
        
        window!.makeKeyAndVisible()
        
        GlobalStyle.apply()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // if was logged in, but session is invalid, log the user out.
        let currentlyLoggedIn = AccountManager.isLoggedIn()
        if let currClient = Clerk.shared.currentClient, currentlyLoggedIn {
            Clerk.shared.getClient(clientJWT: currClient.JWT) { result in
                switch result {
                case .success:
                    if !AccountManager.isLoggedIn() {
                        self.transitionToMain()
                    }
                case .failure:
                    self.transitionToMain()
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification recieved")
        print(userInfo)
    }
    
    // MARK: - Transition
    func transitionToMain() {
        let mainTabBarController = MainTabBarController.storyboardInit()        
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
        
        mainTabBarController.view.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            mainTabBarController.view.alpha = 1.0
        })
    }

    // MARK: - Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("APNS Device Token: \(token)")
        
        
        NetworkController.shared.postDevice(apnsToken: token) { (error) in
            if error == nil {
                print("Posted Device Token")
            } else {
                print("Adding Device Token Failed \(error!)")
            }
        }
    }
    
    //Called if unable to register for APNS.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Didn't Register \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("asdf")
    }
}
