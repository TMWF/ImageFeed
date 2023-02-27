//
//  OAuthTokenStorage.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 23.02.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "token"
    
    var token: String {
        get {
            UserDefaults.standard.string(forKey: tokenKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
            print("Token stored successfully")
        }
    }
}
