//
//  HorizontalScrollingTableViewCell.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 9/11/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit
import SDWebImage

enum HorizontalScrollingCellType {
    case handbook, story, video
    
    
    func cellSize() -> CGSize {
        switch self {
        case .handbook:
            return CGSize(width: 190, height: 260)
        case .video:
            return CGSize(width: 220, height: 140)
        case .story:
            return CGSize(width: 180, height: 180)
        }
    }
    
    func title() -> String {
        switch self {
        case .handbook:
            return "TRADING PROGRAMS"
        case .video:
            return "Videos"
        case .story:
            return "TRADING LESSONS"
        }
    }
}

protocol HorizontalScrollingTableViewCellDelegate: class {
    func didSelectCell(cellData: ImageCollectionViewCellData)
    func collectionViewDidScroll(cell: HorizontalScrollingTableViewCell, offset: CGFloat)
}

class HorizontalScrollingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HorizontalScrollingTableViewCellReuseIdentifier"
    static let nib = UINib(nibName: "HorizontalScrollingTableViewCell", bundle: nil)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var cellType: HorizontalScrollingCellType = .handbook
    
    var insets: UIEdgeInsets!
    var imageCellData = [ImageCollectionViewCellData]()
    
    weak var delegate: HorizontalScrollingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        
        collectionView.contentOffset = CGPoint(x: -collectionView.contentInset.left, y: 0)
        
        insets = UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16)
        collectionView.contentOffset = CGPoint(x: -insets.left, y: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insets.left, bottom: 0, right: insets.right)

        titleLabel.textColor = UIColor.black
        titleLabel.font = TEFont.barlow(weight: .bold, size: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        collectionView.contentOffset = CGPoint(x: -insets.left, y: 0)
    }
    
    func setup(cellType: HorizontalScrollingCellType, data: [ImageCollectionViewCellData]) {
        titleLabel.text = cellType.title()
        
        collectionViewHeightConstraint.constant = cellType.cellSize().height*2+10
        collectionViewFlowLayout.itemSize = cellType.cellSize()

        imageCellData = data
        collectionView.reloadData()
    }
}

extension HorizontalScrollingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(cellData: imageCellData[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.setData(data: imageCellData[indexPath.row])
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.collectionViewDidScroll(cell: self, offset: scrollView.contentOffset.x)
    }

}
