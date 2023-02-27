//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 23.02.2023.
//

import Foundation

final class OAuth2Service {
    public enum NetworkError: Error {
        case codeError, invalidTokenError
    }
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
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
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                    }
                } else {
                    fatalError("Unexpected error occured")
                }
            }
            task.resume()
        }
    }
}
