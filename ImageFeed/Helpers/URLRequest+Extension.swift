//
//  URLRequest+Extension.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 23.02.2023.
//

import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    
    static func makeHTTPRequestWithQueryItems(
        _ queryItems: [URLQueryItem],
        path: String,
        httpMethod: String,
        baseURL: String = "https://api.unsplash.com"
    ) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { fatalError("Invalid url components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
