//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 16.04.2023.
//

import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func getCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat
    func fetchPhotosNextPage()
    func updatePhotos()
    func changeLike(for photo: Photo, handler: @escaping (Result<Void, Error>) -> Void)
    func configCell(for cell: ImageListCell, with indexPath: IndexPath)
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?

    private let imageListService: ImageListServiceProtocol
    private var imageListServiceObserver: NSObjectProtocol?
    private (set) var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(imageListService: ImageListServiceProtocol) {
        self.imageListService = imageListService
        
        self.imageListServiceObserver = NotificationCenter.default
            .addObserver(forName: ImageListService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                
                guard let self = self else { return }
                
                let startIndex = self.photos.count
                self.updatePhotos()
                self.view?.updateTableViewAnimated(startIndex: startIndex, newCount: imageListService.photos.count)
            })
    }
    
    func getCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func updatePhotos() {
        photos = imageListService.photos
    }
    
    func changeLike(for photo: Photo, handler: @escaping (Result<Void, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        imageListService.changeLike(
            photoID: photo.id,
            isLiked: !photo.isLiked
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
                self.replacePhotoWithNewValue(photo: photo)
                handler(.success(()))
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                handler(.failure(error))
            }
        }
    }
    
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let photoURL = URL(string: photo.thumbImageURL) else { return }
        
        let likeImage = photo.isLiked ? UIImage(named: Constants.likeImageOn) : UIImage(named: Constants.likeImageOff)
        cell.delegate = view
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(
            with: photoURL,
            placeholder: UIImage(named: "Stub")
        ) { [weak self] _ in
            guard let self = self else { return }
            self.view?.reloadRowFor(indexPath: indexPath)
        }
        cell.likeButton.setImage(likeImage, for: .normal)
        
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
    }
    
    private func replacePhotoWithNewValue(photo: Photo) {
        if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            photos[index] = newPhoto
        }
    }
}

