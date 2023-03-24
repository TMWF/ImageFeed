//
//  Profile.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 13.03.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    var loginName: String {
        "@\(username)"
    }
    let bio: String
    
    private init(username: String, name: String, bio: String) {
        self.username = username
        self.name = name
        self.bio = bio
    }
    
    static func convertProfileResultToProfile(_ profileResult: ProfileResult) -> Profile {
        Profile(
            username: profileResult.username ?? "",
            name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")",
            bio: profileResult.bio ?? ""
        )
    }
}
