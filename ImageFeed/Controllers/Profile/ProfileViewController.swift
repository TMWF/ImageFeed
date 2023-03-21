//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 17.02.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle.fill")
        guard let image else { fatalError("Failed to load profile picture from assets") }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var logoutButton: UIButton = {
        let image = UIImage(named: "logout_button")
        guard let image else { fatalError("Failed to load image for logout button from assets") }
        let button = UIButton.systemButton(with: image, target: ProfileViewController.self, action: #selector(didTapLogoutButton))
        button.tintColor = .hexStringToUIColor(hex: "#F56B6C")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont(name: "SF Pro Bold", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor.hexStringToUIColor(hex: "AEAFB4")
        label.font = UIFont(name: "System", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world"
        label.textColor = .white
        label.font = UIFont(name: "System", size: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        activateConstraints()
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
        initializeObserver()
        updateAvatar()
    }
}

private extension ProfileViewController {
    func initializeObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
            )  { [weak self] _ in
                guard let self else { return }
                print("NOTIFICATION TRIGGERED SUCCSESSFULLY")
                self.updateAvatar()
            }
    }
    
    func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(userNameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor, constant: 0),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor)
        ])
    }
    
    @objc func didTapLogoutButton() {
        
    }
    
    func updateProfileDetails(profile: Profile) {
        descriptionLabel.text = profile.bio
        loginNameLabel.text = profile.loginName
        userNameLabel.text = profile.name
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"), options: [.processor(processor)])
        avatarImageView.kf.indicatorType = .activity
    }
}
