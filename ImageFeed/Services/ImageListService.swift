//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 28.03.2023.
//

import Foundation

final class ImageListService {
    private struct EmptyBody: Decodable { }
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage = 0
    private(set) var photos = [Photo]()
    private let tokenStorage = OAuth2TokenStorage()
    
    private lazy var dateFormatter = {
        return ISO8601DateFormatter()
    }()
    
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        lastLoadedPage += 1
        let nextPage = lastLoadedPage
    
        print("Next page is \(nextPage)")
        let queryItems = [URLQueryItem(name: "page", value: "\(nextPage)")]
        var request = URLRequest.makeHTTPRequestWithQueryItems(queryItems, path: "/photos", httpMethod: "GET")
        request.setValue("Bearer \(tokenStorage.token)", forHTTPHeaderField: "Authorization")
        
        let newTask = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                let photos = self.convertPhotoResultToPhotos(photoResult)
                assert(Thread.isMainThread)
                self.photos.append(contentsOf: photos)
                
                NotificationCenter.default
                    .post(name: ImageListService.didChangeNotification,
                          object: self,
                          userInfo: ["photos": self.photos])
            case .failure(let error):
                switch error {
                    // TODO: - 500 status code handling
                case NetworkError.httpStatusCode, NetworkError.urlSessionError:
                    print(error.localizedDescription)
                case NetworkError.urlRequestError:
                    print(error)
                default:
                    fatalError("Unexpected error occured")
                }
                lastLoadedPage -= 1
            }
            self.task = nil
        })
        
        DispatchQueue.main.async {
            self.task = newTask
        }
        newTask.resume()

    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLiked ? "DELETE" : "POST"
        )
        request.setValue("Bearer \(tokenStorage.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<EmptyBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    
                    self.photos[index] = newPhoto
                }

                completion(.success(Void()))
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
        })
        task.resume()
    }
    
    private func convertPhotoResultToPhotos(_ photoresult: [PhotoResult]) -> [Photo] {
        var photos = [Photo]()
        
        for photo in photoresult {
            let newPhoto = Photo(
                id: photo.id,
                size: CGSize(width: photo.width, height: photo.height),
                createdAt: dateFormatter.date(from: photo.createdAt),
                welcomeDescription: photo.description,
                thumbImageURL: photo.urls.thumb,
                largeImageURL: photo.urls.full,
                isLiked: photo.likedByUser
            )
            photos.append(newPhoto)
        }
        return photos
    }
}
