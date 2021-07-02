//
//  LoginHeaderTableViewCell.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/25/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

protocol LoginHeaderTableViewCellDelegate: class {
    func didLogout()
    func didLogin()
}

class LoginHeaderTableViewCell: UITableViewCell {
    static let reuseIdentifier = "LoginHeaderTableViewCellReuseIdentifier"
    static let nib = UINib(nibName: "LoginHeaderTableViewCell", bundle: nil)
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var groupChatLabel: UILabel!
    @IBOutlet weak var notAMemberImage: UIImageView!
    
    weak var delegate: LoginHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // login string
        let loginAttributedString: NSMutableAttributedString
        if AccountManager.isLoggedIn() {
            let session = Clerk.shared.currentClient!.session!
            loginAttributedString = NSMutableAttributedString(string: "Welcome \(session.user.firstName)!")
            loginAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText , range: NSRange(location: 0, length: loginAttributedString.length))

            if AccountManager.isMember() {
                notAMemberImage.isHidden = true
                groupChatLabel.isHidden = true
            }
        } else {
            loginAttributedString = NSMutableAttributedString(string: "Already a Member? Sign in")
            let range = loginAttributedString.string.range(of: "Sign in")!
            
            let nrange = NSRange(range, in: loginAttributedString.string)
            loginAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText , range: NSRange(location: 0, length: loginAttributedString.length-nrange.length))
            
            
            loginAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.te_green , range: nrange)
        }

        loginAttributedString.addAttribute(NSAttributedString.Key.font, value: TEFont.barlow(weight: .bold, size: 22), range: NSRange(location: 0, length: loginAttributedString.string.count))
        loginLabel.attributedText = loginAttributedString
        
        // group chat string
        let groupChatAttributedString = NSMutableAttributedString(string: "Click here to begin your 10 Step Challenge!")
        let clickHereRange = NSRange(groupChatAttributedString.string.range(of: "Click here")!, in: groupChatAttributedString.string)
        
        groupChatAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: NSRange(location: clickHereRange.length, length: groupChatAttributedString.string.count-clickHereRange.length))

        groupChatAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.te_green , range: clickHereRange)
        groupChatAttributedString.addAttribute(NSAttributedString.Key.font, value: TEFont.barlow(weight: .regular, size: 20), range: NSRange(location: 0, length: groupChatAttributedString.string.count))

        groupChatLabel.attributedText = groupChatAttributedString
    }
    
    @IBAction func doLogin() {
        if AccountManager.isLoggedIn() {
            delegate?.didLogout()
        } else {
            delegate?.didLogin()
        }
    }
    
    @IBAction func doGroupMeButton() {
        UIApplication.shared.open(URL(string: "https://join.tradingexperts.org/90day-trial-membership")!, options: [:], completionHandler: nil)
    }
}
