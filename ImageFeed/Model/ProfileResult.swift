//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 13.03.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let id: String
    let updatedAt: String?
    let username, firstName, lastName, twitterUsername: String?
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let followedByUser: Bool
    let downloads, uploadsRemaining: Int
    let instagramUsername, email: String?
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case downloads
        case uploadsRemaining = "uploads_remaining"
        case instagramUsername = "instagram_username"
        case email, links
    }
    
    struct Links: Codable {
        let linksSelf, html, photos, likes: String
        let portfolio: String

        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case html, photos, likes, portfolio
        }
    }
}


