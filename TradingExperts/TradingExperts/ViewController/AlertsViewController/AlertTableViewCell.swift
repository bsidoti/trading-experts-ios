//
//  AlertTableViewCell.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 8/25/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import SDWebImage

class AlertTableViewCell: UITableViewCell {
    lazy var relFormatter: RelativeDateTimeFormatter = {
        let rf = RelativeDateTimeFormatter()
        rf.unitsStyle = .full
        return rf
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "MMM dd, yyyy 'at' h:mm a"
        return df
    }()
    
    static let reuseIdentifier = "AlertTableViewCellReuseIdentifier"
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var alertImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        borderView.backgroundColor = UIColor.te_lightGray
        
        
        borderView.layer.borderColor = UIColor.te_darkGray.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 3
        borderView.clipsToBounds = true
        borderView.isUserInteractionEnabled = true
        
        alertImageView.contentMode = .scaleAspectFill
        alertImageView.clipsToBounds = true
        dateLabel.font = TEFont.barlow(weight: .semiBold, size: 12)
        dateLabel.textColor = UIColor.te_darkGray
        
        bodyLabel.font = TEFont.barlow(weight: .semiBold, size: 16)
        bodyLabel.textColor = UIColor.darkText
    }
    
    override func prepareForReuse() {
        alertImageView.sd_cancelCurrentImageLoad()
    }
    
    func setup(alert: Alert) {
        
//        let exampleDate = Date().addingTimeInterval(-15000)

        // ask for the full relative date

        // get exampleDate relative to the current date
//        let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
        
        // print it out
//        print("Relative date is: \(relativeDate)")
        bodyLabel.text = alert.body
        dateLabel.text = relFormatter.localizedString(for: alert.getCreatedAtDate(), relativeTo: Date())
        
        if let url = URL(string: alert.imageUrl) {
            alertImageView.sd_setImage(with: url)
        }
    }
}
