//
//  ImageCollectionViewCell.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/21/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellData {
    var image: UIImage? { get }
    var imageUrlString: String? { get }
    var isMemberOnly: Bool { get }
}

class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCollectionViewCellReuseIdentifier"
    static let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var membersOnlyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white //lightGray
        membersOnlyLabel.font = TEFont.barlow(weight: .regular, size: 14)
        membersOnlyLabel.text = "MEMBERS ONLY"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()        
        imageView.image = nil
        overlayView.isHidden = false
    }
    
    
    func setData(data: ImageCollectionViewCellData) {
        overlayView.isHidden = !data.isMemberOnly || AccountManager.isMember()
        
        if let image = data.image {
            imageView.image = image
        } else if let imageUrlString = data.imageUrlString, let url = URL(string: imageUrlString) {
            imageView.sd_setImage(with: url)
        }
    }
}
