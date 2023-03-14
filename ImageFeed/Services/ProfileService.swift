//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 13.03.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init(task: URLSessionTask? = nil, lastToken: String? = nil) {
        self.task = task
        self.lastToken = lastToken
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global().async {
            let task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = Profile.convertProfileResultToProfile(response)
                        self.profile = profile
                        completion(.success(profile))
                        self.task = nil
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    switch error {
                    case NetworkError.httpStatusCode, NetworkError.urlSessionError:
                        completion(.failure(error))
                    case NetworkError.urlRequestError:
                        completion(.failure(error))
                        self.lastToken = nil
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
}
