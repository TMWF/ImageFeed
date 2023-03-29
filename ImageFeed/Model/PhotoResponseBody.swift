//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 29.03.2023.
//

import Foundation

struct PhotoResponseBody: Decodable {
    let photos: [PhotoResult]
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: String
    let height: String
    let description: String?
    let likedByUser: Bool
    let urls: URLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

struct URLs: Decodable {
    let raw: String?
    let full: String
    let regular: String?
    let small: String?
    let thumb: String
}
