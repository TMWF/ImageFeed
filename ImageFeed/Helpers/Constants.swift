//
//  Constants.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 04.02.2023.
//

import Foundation

struct Constants {
    static let unsplashAutorizeURL = "https://unsplash.com/oauth/authorize"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else { fatalError("Error occured while trying to create base api URL")}
        return url
    }()
    static let accessScope = "public+read_user+write_likes"
    static let accessKey = "bTvAmkPrW1p5aHFxCQNRzgFL8OwygTj0t70Qryk2t98"
    static let secretKey = "irOnn5eGjJ08UWZKIm3NrlgYaIPIoPgb3DleuhzMnic"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let likeImageOn = "like_button_on"
    static let likeImageOff = "like_button_off"
    
    static let segueToSingleImageViewController = "ShowSingleImage"
    static let showWebViewSegueIdentifier = "ShowWebView"
    
    private init() { }
}
