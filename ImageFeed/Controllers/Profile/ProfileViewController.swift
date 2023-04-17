//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 17.02.2023.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func updateAvatar(with url: URL)
    func updateProfileDetails(with profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private var avatarImageView: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle.fill")
        guard let image else { fatalError("Failed to load profile picture from assets") }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let image = UIImage(named: "logout_button")
        guard let image else { fatalError("Failed to load image for logout button from assets") }
        let button = UIButton.systemButton(with: image, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = .hexStringToUIColor(hex: "#F56B6C")
        button.accessibilityIdentifier = "logoutButton"
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
    
    var presenter: ProfileViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hexStringToUIColor(hex: "#1A1B22")
        addSubviews()
        activateConstraints()
        presenter?.viewDidLoad()
    }
    
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.circle.fill"),
            options: [.processor(processor),
                .cacheSerializer(FormatIndicatedCacheSerializer.png)]
        )
        avatarImageView.kf.indicatorType = .activity
    }
    
    func updateProfileDetails(with profile: Profile?) {
        guard let profile else { return }
        descriptionLabel.text = profile.bio
        loginNameLabel.text = profile.loginName
        userNameLabel.text = profile.name
    }
}

private extension ProfileViewController {
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
        showConfirmationAlert()
    }
    
    func showConfirmationAlert() {
        AlertBuilder(viewController: self)
            .withTitle("Пока, пока!")
            .andMessage("Уверены что хотите выйти?")
            .preferredStyle(.alert)
            .onSuccessAction(title: "Нет") {  _ in  }
            .onCancelAction(title: "Да") { [weak self] _ in
                guard let self else { return }
                self.presenter?.performLogout()
            }
            .show()
    }
}
