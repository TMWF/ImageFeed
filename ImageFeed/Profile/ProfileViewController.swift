//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 17.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
}
