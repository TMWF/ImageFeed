//
//  WebViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 12.04.2023.
//

import Foundation

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: CGFloat)
    func setProgressHidden(_ isHidden: Bool)
}
