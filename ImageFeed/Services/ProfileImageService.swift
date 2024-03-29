//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 14.03.2023.
//

import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var userName: String?
    
    private init() { }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(tokenStorage.token)", forHTTPHeaderField: "Authorization")
        
        let newTask = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                let imageURL = userResult.profileImage?.small
                self.avatarURL = imageURL
                guard let avatarURL = self.avatarURL else { return }
                completion(.success(avatarURL))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": avatarURL])
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode, NetworkError.urlSessionError:
                    print(error.localizedDescription)
                    completion(.failure(error))
                case NetworkError.urlRequestError:
                    print(error)
                    completion(.failure(error))
                default:
                    fatalError("Unexpected error occured")
                }
            }
            self.task = nil
        })
        
        DispatchQueue.main.async {
            self.task = newTask
        }
        newTask.resume()
    }
}
