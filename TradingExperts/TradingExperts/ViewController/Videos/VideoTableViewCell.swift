//
//  VideoTableViewCell.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/19/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "VideoTableViewCellReuseIdentifier"
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var loadingBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        borderView.layer.borderColor = UIColor.darkGray.cgColor
//        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 10
        borderView.clipsToBounds = true
        borderView.isUserInteractionEnabled = true
        
        videoImageView.contentMode = .scaleAspectFit
        resetCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        videoImageView.sd_cancelCurrentImageLoad()
        playerView.isHidden = true
        loadingBackground.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showLoading(loading: Bool) {
        if loading {
            loadingBackground.isHidden = false
            activityIndicator.startAnimating()
        } else {
            loadingBackground.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func setup(video: TEVideo) {
        if let imageUrlString = video.imageUrl, let url = URL(string: imageUrlString) {
            videoImageView.sd_setImage(with: url)
        }
    }
}
