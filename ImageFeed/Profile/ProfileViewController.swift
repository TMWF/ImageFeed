//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 17.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
}
