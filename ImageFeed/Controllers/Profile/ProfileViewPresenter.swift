//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 15.04.2023.
//

import Foundation
import WebKit

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
        guard
            let profileImageURL = helper.getAvatarURL(),
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(with: url)
    }
    
    func performLogout() {
        OAuth2TokenStorage().token = ""
        cleanCookies()
        switchToSplashViewContoller()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToSplashViewContoller() {
        Constants.splashScreenFirstTimeAppeared = true
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
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
