//
//  UserResult.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 14.03.2023.
//

import Foundation

struct UserResult: Decodable {
    let id: String?
    let updatedAt: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let instagramUsername: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int?
    let totalCollections: Int?
    let followedByUser: Bool?
    let followersCount: Int?
    let followingCount: Int?
    let downloads: Int?
    let social: Social?
    let profileImage: ProfileImage?
    let badge: Badge?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case updatedAt = "updated_at"
        case username = "username"
        case name = "name"
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio = "bio"
        case location = "location"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case downloads = "downloads"
        case social = "social"
        case profileImage = "profile_image"
        case badge = "badge"
        case links = "links"
    }
}

// MARK: - Badge
struct Badge: Decodable {
    let title: String?
    let primary: Bool?
    let slug: String?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case primary = "primary"
        case slug = "slug"
        case link = "link"
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

// MARK: - Social
struct Social: Decodable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
    }
}
