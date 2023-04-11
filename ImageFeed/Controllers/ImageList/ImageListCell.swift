//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 29.01.2023.
//

import UIKit

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    weak var delegate: ImageListCellDelegate?
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImageView.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: Constants.likeImageOn) : UIImage(named: Constants.likeImageOff)
        likeButton.setImage(likeImage, for: .normal)
    }
}
