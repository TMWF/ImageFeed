//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 12.04.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
