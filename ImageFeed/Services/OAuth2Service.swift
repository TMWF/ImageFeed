//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 23.02.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void )
}

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() { }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = self.urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let tokenResponse):
                completion(.success(tokenResponse.accessToken))
                self.task = nil
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode, NetworkError.urlSessionError:
                    completion(.failure(error))
                case NetworkError.urlRequestError:
                    completion(.failure(error))
                    self.lastCode = nil
                default:
                    fatalError("Unexpected error occured")
                }
            }
        }
        DispatchQueue.main.async {
            self.task = task
        }
        task.resume()
    }
}
