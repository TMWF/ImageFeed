//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Leo Bonhart on 13.04.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: WebViewControllerProtocol?
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        view?.load(request: URLRequest(url: URL(string: "Apple.com")! ))
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
