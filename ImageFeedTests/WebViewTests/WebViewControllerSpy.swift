//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Leo Bonhart on 13.04.2023.
//

import Foundation
import ImageFeed

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var isLoadRequestCalled = false
    
    func load(request: URLRequest) {
        isLoadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: CGFloat) { }
    
    func setProgressHidden(_ isHidden: Bool) { }
}
