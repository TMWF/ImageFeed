//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Leo Bonhart on 15.04.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewDidLoadAddsObserver() {
        //given
        let vc = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        // when
        _ = vc.view
        //then
        XCTAssertTrue(presenter.observerAdded)
    }
    
    func testViewDidLoadUpdatesProfileDetailsAndAvatar() {
        // given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        vc.presenter = presenter
        presenter.view = vc
        // when
        presenter.viewDidLoad()
        //then
        XCTAssertTrue(vc.updateProfileDetailsCalled)
    }
    
    func testViewDidLoadUpdatesAvatar() {
        // given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(helper: ProfilePresenterHelperStub())
        vc.presenter = presenter
        presenter.view = vc
        // when
        presenter.viewDidLoad()
        //then
        XCTAssertTrue(vc.updateAvatarCalled)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?
    var observerAdded = false

    func viewDidLoad() {
        viewDidLoadCalled = true
        view?.updateProfileDetails(with: nil)
        initializeObserver()
        view?.updateAvatar(with: Constants.defaultBaseURL)
    }
    
    private func initializeObserver() {
        observerAdded = true
    }
    
    func performLogout() { }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false

    func updateProfileDetails(with profile: Profile?) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }
}

final class ProfilePresenterHelperStub: ProfilePresenterHelperProtocol {
    func getAvatarURL() -> String? {
        "apple.com"
    }
}


