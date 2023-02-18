//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 18.02.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
