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
}
