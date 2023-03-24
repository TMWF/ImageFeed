//
//  UserResult.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 14.03.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case links = "links"
    }
}
// MARK: - Links
struct Links: Decodable {
    let linksSelf: String?
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html = "html"
        case photos = "photos"
        case likes = "likes"
        case portfolio = "portfolio"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Decodable {
    let small: String?
    let medium: String?
    let large: String?

    enum CodingKeys: String, CodingKey {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
}
