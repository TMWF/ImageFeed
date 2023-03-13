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
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    public enum NetworkError: Error {
        case codeError, invalidTokenError
    }
    
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
        DispatchQueue.global().async {
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let data = data,
                   let response = response,
                   let httpResponse = response as? HTTPURLResponse
                {
                    let statusCode = httpResponse.statusCode
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                            DispatchQueue.main.async {
                                completion(.success(response.accessToken))
                                self.task = nil
                            }
                        } catch {
                            fatalError("Unexpected error occured while trying to get access token from response body")
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(NetworkError.codeError))
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.lastCode = nil
                    }
                } else {
                    fatalError("Unexpected error occured")
                }
            }
            DispatchQueue.main.async {
                self.task = task
            }
            task.resume()
        }
    }
}
