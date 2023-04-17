//
//  ProfilePresenterHelper.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 15.04.2023.
//

import Foundation
import WebKit

protocol ProfilePresenterHelperProtocol {
    func getAvatarURL() -> URL?
    func performLogout()
}

final class ProfilePresenterHelper: ProfilePresenterHelperProtocol {
    private let profileImageService = ProfileImageService.shared
    
    func getAvatarURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
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
}
