//
//  LogoutViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 3/26/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    
    var loginVC: CKLoginViewController!
    var loginNav: UINavigationController!

    class func storyboardInit() -> ProfileViewController {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.te_green
        loginButton.tintColor = UIColor.white
        loginButton.titleLabel?.font = TEFont.barlow(weight: .bold, size: 20)
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        
        loginVC = CKLoginViewController(clerkObj: Clerk.shared)
        loginVC.delegate = self
        loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
            
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        
        nameLabel.font = TEFont.barlow(weight: .bold, size: 22)
        nameLabel.textColor = UIColor.darkText
        
        emailLabel.font = TEFont.barlow(weight: .bold, size: 18)
        emailLabel.textColor = UIColor.darkText
        
        accountTypeLabel.font = TEFont.barlow(weight: .bold, size: 18)
        accountTypeLabel.textColor = UIColor.darkText
        
        
        logoutButton.backgroundColor = UIColor.te_green
        logoutButton.tintColor = UIColor.white
        logoutButton.titleLabel?.font = TEFont.barlow(weight: .regular, size: 16)
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height/2

        
        bgView.backgroundColor = UIColor(numericRed: 255, green: 255, blue: 255, alpha: 0.6)
        bgView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccountManager.isLoggedIn() {
            let session = Clerk.shared.currentClient!.session!
            profileImageView.sd_setImage(with: session.user.profileImageURL)
            emailLabel.text = session.user.primaryEmailAddress
            nameLabel.text = "\(session.user.firstName) \(session.user.lastName)"
            accountTypeLabel.text = session.user.isAlpha ? "Alpha Member" : "No membership"
            
            loginButton.isHidden = true
            profileStackView.isHidden = false
        } else {
            loginButton.isHidden = false
            profileStackView.isHidden = true
            bgView.isHidden = true
        }
    }

    @IBAction func doSignIn() {
        present(loginNav, animated: true, completion: nil)
    }
    
    @IBAction func doSignOut() {
        let alert = UIAlertController(title: "Are you sure you'd like to sign out?", message: nil, preferredStyle: .alert)
        
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
}


// MARK: - CKLoginViewControllerDelegate
extension ProfileViewController: CKLoginViewControllerDelegate {
    func signedIn() {
        appDelegate().transitionToMain()
    }
}
