//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 29.01.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
