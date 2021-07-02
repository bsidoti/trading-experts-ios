//
//  UIViewControllerExtension.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/13/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

extension UIViewController {
    func wrapInNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        navController.navigationBar.isTranslucent = false
        
        return navController
    }
    
    func wrapInModalNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        navController.navigationBar.isTranslucent = false
        navController.modalPresentationStyle = .fullScreen
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(modalWrapClose))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        return navController
    }
    
    @objc func modalWrapClose() {
        dismiss(animated: true, completion: nil)
    }
}
