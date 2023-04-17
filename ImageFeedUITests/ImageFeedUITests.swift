//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Leo Bonhart on 17.04.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
           
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("gpliev777@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("d#rWz3Bq?RxdVrW")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        let tabBarElement = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(tabBarElement.waitForExistence(timeout: 5))
        tabBarElement.tap()
        
        XCTAssertTrue(app.staticTexts["Joe Louis"].exists)
        XCTAssertTrue(app.staticTexts["@themetal"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
//    func testAuth() throws {
//        app.buttons["Authenticate"].tap()
//
//        let webView = app.webViews["UnsplashWebView"]
//        XCTAssertTrue(webView.waitForExistence(timeout: 5))
//
//        let loginTextField = webView.descendants(matching: .textField).element
//        loginTextField.tap()
//        loginTextField.typeText("kirilloffkostya@gmail.com")
//        webView.swipeUp()
//
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        passwordTextField.tap()
//        passwordTextField.typeText("KirillOff")
//        webView.swipeUp()
//
//        webView.buttons["Login"].tap()
//
//        let tablesQuery = app.tables
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//
//        cell.waitForExistence(timeout: 5)
//    }
//
//    func testFeed() throws {
//        let tablesQuery = app.tables
//
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        cell.swipeUp()
//
//        sleep(2)
//
//        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
//
//        cellToLike.buttons["heartButton"].tap()
//        sleep(2)
//        cellToLike.buttons["heartButton"].tap()
//
//        sleep(2)
//
//        cellToLike.tap()
//
//        sleep(2)
//
//        let image = app.scrollViews.images.element(boundBy: 0)
//        // Zoom in
//        image.pinch(withScale: 3, velocity: 1) // zoom in
//        // Zoom out
//        image.pinch(withScale: 0.5, velocity: -1)
//
//        let navBackButtonWhiteButton = app.buttons["backButton"]
//        navBackButtonWhiteButton.tap()
//    }
//
//    func testProfile() throws {
//        sleep(3)
//        app.tabBars.buttons.element(boundBy: 1).tap()
//
//        sleep(3)
//
//        XCTAssertTrue(app.staticTexts["Konstantin Kirillov"].exists)
//        XCTAssertTrue(app.staticTexts["@kirill_off"].exists)
//
//        app.buttons["escapeButton"].tap()
//
//        app.alerts["byeAlert"].scrollViews.otherElements.buttons["Да"].tap()
//    }

}
