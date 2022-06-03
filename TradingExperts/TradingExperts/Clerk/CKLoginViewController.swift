//
//  CKLoginViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 4/20/21.
//  Copyright © 2021 Braden Sidoti. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol CKLoginViewControllerDelegate: AnyObject {
    func signedIn()
}

class CKLoginViewController: UIViewController {
    var webViewURLObserver: NSKeyValueObservation!
    
    let clerkObj: Clerk
    
    var webDataStore: WKWebsiteDataStore!
    weak var delegate: CKLoginViewControllerDelegate?

    init(clerkObj: Clerk) {
        self.clerkObj = clerkObj
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        self.modalPresentationStyle = .fullScreen
        self.title = "Sign in"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doCancel))
        cancelButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = cancelButton
        
        // setup WKWebview / Datastore
        webDataStore = WKWebsiteDataStore.nonPersistent()
        let webConfig = WKWebViewConfiguration()
        webConfig.websiteDataStore = webDataStore
        
        let loginWebView = WKWebView(frame: .zero, configuration: webConfig)
        let url = URL(string: clerkObj.signInURL)!
        let request = URLRequest(url: url)
        loginWebView.load(request)
        
        self.webViewURLObserver = loginWebView.observe(\.url, options: .new) { [weak self] webview, change in
            guard let strongSelf = self else {
                return
            }
            let urlMatch = change.newValue!!.absoluteString
            
            if urlMatch.hasSuffix("default-redirect") || urlMatch == strongSelf.clerkObj.afterSignInURL {
                strongSelf.webDataStore.httpCookieStore.getAllCookies { (cookies: [HTTPCookie]) in
                    for cook in cookies {
                        if cook.name == "__client" {
                            strongSelf.clerkObj.getClient(clientJWT: cook.value, completion: { (result: Result<Client>) in
                                strongSelf.delegate?.signedIn()
                            })
                            return
                        }
                    }
                }
            }
        }

        view = loginWebView
    }
    
    @objc func doCancel() {
        dismiss(animated: true, completion: nil)
    }
}
