//
//  GettingStartedViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 3/26/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import WebKit

protocol PdfData {
    var pdfUrl: URL { get }
}

class PdfViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var data: PdfData!
    
    class func storyboardInit(data: PdfData) -> PdfViewController {
        let storyboard = UIStoryboard.init(name: "PdfViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
        vc.data = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: data.pdfUrl)
        webView.load(request)
    }
}
