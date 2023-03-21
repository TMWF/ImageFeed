//
//  OAuthTokenStorage.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 23.02.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "token"
    
    var token: String {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey) ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            print("Token stored successfully")
        }
    }
}
