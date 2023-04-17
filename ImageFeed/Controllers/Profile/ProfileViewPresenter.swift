//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 15.04.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func performLogout()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let helper: ProfilePresenterHelperProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(helper: ProfilePresenterHelperProtocol = ProfilePresenterHelper()) {
        self.helper = helper
    }
    
    func viewDidLoad() {
        view?.updateProfileDetails(with: profileService.profile)
        initializeObserver()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard let url = helper.getAvatarURL() else { return }
        view?.updateAvatar(with: url)
    }
    
    func performLogout() {
        helper.performLogout()
    }
    
    private func initializeObserver() {
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

}
