//
//  MainTabBarController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 1/9/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    class func storyboardInit() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! MainTabBarController
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let learningVC = LearningCenterViewController.storyboardInit()
        let learningNavController = learningVC.wrapInNavigationController()
        learningNavController.tabBarItem.image = UIImage(named: "learning_center_icon")!
        
        let alertsViewController = AlertsViewController.storyboardInit()
        let alertsNavController = alertsViewController.wrapInNavigationController()
        alertsNavController.tabBarItem.image = UIImage(named: "alerts_icon")!
        
        let videosVC = VideosViewController.storyboardInit()
        let videosNavController = videosVC.wrapInNavigationController()
        videosNavController.tabBarItem.image = UIImage(named: "videos_icon")!

        let profileVC = ProfileViewController.storyboardInit()
        let provileNavController = profileVC.wrapInNavigationController()
        provileNavController.tabBarItem.image = UIImage(named: "profile_icon")!
        provileNavController.tabBarItem.title = "Profile"
        
        viewControllers = [learningNavController, alertsNavController, videosNavController, provileNavController]
    }
}

// MARK: - CKLoginViewControllerDelegate
extension MainTabBarController: CKLoginViewControllerDelegate {
    func signedIn() {
        appDelegate().transitionToMain()
    }
}
