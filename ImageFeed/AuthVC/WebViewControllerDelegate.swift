//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 22.02.2023.
//

import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewController)
}
