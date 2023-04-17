//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Leo Bonhart on 17.04.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
    func testGetNewPhotoFromPresenter() throws {
        //given
        let imageServiceMock = ImageListServiceStub()
        let presenter = ImageListPresenter(imageListService: imageServiceMock)
        
        //when
        presenter.fetchPhotosNextPage()
        presenter.updatePhotos()
        
        //then
        XCTAssertTrue(presenter.photos.count == 3)
    }
    
    func testDidInsertedRowsAfterFetching() throws {
        //given
        let imageServiceMock = ImageListServiceStub()
        let presenter = ImageListPresenter(imageListService: imageServiceMock)
        let imageListVCSpy = ImageListVCSpy()
        imageListVCSpy.configure(presenter)
        
        //when
        presenter.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(imageListVCSpy.didInsertedRowsAfterFetching == true)
    }
}

final class ImageListVCSpy: ImageListViewControllerProtocol {
    var didInsertedRowsAfterFetching: Bool = false
    var presenter: ImageListPresenterProtocol?
    
    func updateTableViewAnimated(startIndex: Int, newCount: Int) {
        didInsertedRowsAfterFetching = true
    }
    
    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func reloadRowFor(indexPath: IndexPath) {
        
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImageListCell) {
        
    }
}

final class ImageListServiceStub: ImageListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    func fetchPhotosNextPage() {
        photos = [
            ImageFeed.Photo(id: "1", size: CGSize(width: 20, height: 20), createdAt: nil, welcomeDescription: "welcom1", thumbImageURL: "", largeImageURL: "", isLiked: false),
            ImageFeed.Photo(id: "2", size: CGSize(width: 20, height: 20), createdAt: nil, welcomeDescription: "welcom2", thumbImageURL: "", largeImageURL: "", isLiked: false),
            ImageFeed.Photo(id: "3", size: CGSize(width: 20, height: 20), createdAt: nil, welcomeDescription: "welcom3", thumbImageURL: "", largeImageURL: "", isLiked: false)
        ]
        
        NotificationCenter.default.post(name: ImageListService.didChangeNotification,
                                        object: self,
                                        userInfo: ["Photos": self.photos])
    }
    
    func changeLike(photoID: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
}

