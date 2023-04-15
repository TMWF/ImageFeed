//
//  ProfilePresenterHelper.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 15.04.2023.
//

import Foundation

protocol ProfilePresenterHelperProtocol {
    func getAvatarURL() -> String?
}

final class ProfilePresenterHelper: ProfilePresenterHelperProtocol {
    private let profileImageService = ProfileImageService.shared
    
    func getAvatarURL() -> String? {
        profileImageService.avatarURL
    }
}
