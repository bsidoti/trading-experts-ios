//
//  LearningCenterViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/11/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import UserNotifications
import WebKit

class LearningCenterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cellXOffsetDict = [Int: CGFloat]()
    var handbooks: [Handbook]!
    var stories: [Story]!
    var loginVC: CKLoginViewController!
    var loginNav: UINavigationController!
    
    class func storyboardInit() -> LearningCenterViewController {
        let storyboard = UIStoryboard.init(name: "LearningCenter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LearningCenterViewController") as! LearningCenterViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.te_lightGray
        
        handbooks = Handbook.all()
        stories = Story.all()
        
        tableView.register(HorizontalScrollingTableViewCell.nib, forCellReuseIdentifier: HorizontalScrollingTableViewCell.reuseIdentifier)
        tableView.register(LoginHeaderTableViewCell.nib, forCellReuseIdentifier: LoginHeaderTableViewCell.reuseIdentifier)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.reloadData()
        
        if AccountManager.isMember() {
            registerForPushNotifications()
        }
        
        loginVC = CKLoginViewController(clerkObj: Clerk.shared)
        loginVC.delegate = self
        loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Warning", message: "If you don't accept push notifications you won't recieve alerts about stocks.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    
    private func activateRestoreSpinner() {
        let av = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        av.startAnimating()
        av.style = .medium
        av.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin, UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
        let loadingButton = UIBarButtonItem(customView: av)
        navigationItem.setRightBarButton(loadingButton, animated: false)
    }
}


// MARK: - UITableViewDelegate/DataSource
extension LearningCenterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoginHeaderTableViewCell.reuseIdentifier, for: indexPath) as! LoginHeaderTableViewCell
            cell.delegate = self
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalScrollingTableViewCell.reuseIdentifier, for: indexPath) as! HorizontalScrollingTableViewCell
        if let xOffset = cellXOffsetDict[indexPath.row] {
            cell.collectionView.contentOffset.x = xOffset
        }
        
        cell.delegate = self
        
        switch indexPath.row {
        case 1:
            cell.setup(cellType: .handbook, data: handbooks)
        case 2:
            cell.setup(cellType: .story, data: stories)
        default:
            assertionFailure("invalid indexPath")
        }
        
        return cell
    }
    
}

// MARK: - HorizontalScrollingTableViewCellDelegate
extension LearningCenterViewController: HorizontalScrollingTableViewCellDelegate {
    func didSelectCell(cellData: ImageCollectionViewCellData) {
        if cellData.isMemberOnly && !AccountManager.isMember() {
            return
        }

        
        if let handbook = cellData as? Handbook {
            let vc = PdfViewController.storyboardInit(data: handbook)
            vc.title = handbook.title()
            let pdfNav = vc.wrapInModalNavigationController()
            present(pdfNav, animated: true, completion: nil)
            
        } else if let story = cellData as? Story {
            let vc = PdfViewController.storyboardInit(data: story)
            vc.title = story.title()
            let pdfNav = vc.wrapInModalNavigationController()
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.navigationController!.view.bounds.width-100, height: 44))
            titleLabel.textAlignment = .center
            titleLabel.text = story.title()
            titleLabel.font = TEFont.barlow(weight: .regular, size: 24)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = .white
            vc.navigationItem.titleView = titleLabel

            present(pdfNav, animated: true, completion: nil)

        }
    }
    
    func collectionViewDidScroll(cell: HorizontalScrollingTableViewCell, offset: CGFloat) {
        if let row = tableView.indexPath(for: cell)?.row {
            cellXOffsetDict[row] = offset
        }
    }
}

// MARK: - LoginHeaderTableViewCellDelegate
extension LearningCenterViewController: LoginHeaderTableViewCellDelegate {
    func didLogout() {
        let alert = UIAlertController(title: "Are you sure you'd like to logout?", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            Clerk.shared.endSession { (error) in
                if let err = error {
                    
                    let alert = UIAlertController(title: "Something went wrong. Please try again later\n\nError: \(err)", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                appDelegate().transitionToMain()
            }
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func didLogin() {
        self.present(loginNav, animated: true, completion: nil)
    }
}

// MARK: - CKLoginViewControllerDelegate
extension LearningCenterViewController: CKLoginViewControllerDelegate {
    func signedIn() {
        //        print(clientCookie)
        //
        // need to get user data here...
        // use the Frontennd API w/ the Authorization header
        //
        //        loginVC.dismiss(animated: true, completion: nil)
        appDelegate().transitionToMain()
    }
}
