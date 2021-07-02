//
//  AlertViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/24/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import UIKit
import SimpleImageViewer

class AlertsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bgNonMemberLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    var alerts = [Alert]()
    
    class func storyboardInit() -> AlertsViewController {
        let storyboard = UIStoryboard.init(name: "Alerts", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlertsViewController") as! AlertsViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage: UIImage
        if AccountManager.isMember() {
            bgImage = UIImage(named: "trading-program-bg")!
            bgNonMemberLabel.isHidden = true
            bgView.isHidden = true
        } else {
            bgImage = UIImage(named: "alert-bg")!
            bgNonMemberLabel.isHidden = false
            bgNonMemberLabel.textColor = UIColor.white
            bgNonMemberLabel.font = TEFont.barlow(weight: .bold, size: 20)
            bgView.isHidden = false
        }

        bgImageView.image = bgImage
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: AlertTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
                
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(doRefreshControl), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AccountManager.isMember() {
            self.refreshControl.beginRefreshing()
            refreshAlerts()
            
        }
    }
    
    @objc func doRefreshControl() {
        refreshAlerts()
    }
    
    func refreshAlerts() {
        NetworkController.shared.getAlerts { (result: Result<[Alert]>) in
            switch result {
            case let .success(alerts):
                self.alerts = alerts.sorted(by: { (a1, a2) -> Bool in
                    return a1.createdAt > a2.createdAt
                })
                
                self.tableView.reloadData()
                
            case let .failure(error):
                let title: String
                
                if error is NetworkingError {
                    title = "Networking Error"
                } else if error is ParsingError {
                    title = "Parsing Error"
                } else {
                    title = "Error"
                }
                
                print(error)
                let alert = UIAlertController(title: title, message: "Error fetching Alerts", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
                self.present(alert, animated: true)
            }
            self.refreshControl.endRefreshing()
        }
    }
}

extension AlertsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AlertTableViewCell
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.alertImageView
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reuseIdentifier, for: indexPath) as! AlertTableViewCell
        cell.setup(alert: alerts[indexPath.row])
        
        return cell
    }
}
