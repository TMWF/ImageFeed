//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 27.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private var imageView: UIImageView = {
        let image = UIImage(named: "splash_screen_logo")
        guard let image else { fatalError("Failed to load background image from assets") }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authService: OAuth2ServiceProtocol = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private let alertPresenter: AlertPresenter = AlertPresenterImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAuthVCorStartFetchingUserInfo()
    }
}

private extension SplashViewController {
    //MARK: - UI Setting
    func setUpUI() {
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#1A1B22")
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    //MARK: - Navigation Logic
    func showAuthVCorStartFetchingUserInfo() {
        if (!OAuth2TokenStorage().token.isEmpty) && Constants.splashScreenFirstTimeAppeared {
            print("Switching inside viewDidAppear")
            UIBlockingProgressHUD.show()
            fetchProfile(token: tokenStorage.token)
            Constants.splashScreenFirstTimeAppeared = false
        } else if Constants.splashScreenFirstTimeAppeared {
            print("Segue inside viewDidAppear")
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard
                let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                fatalError("Failed to instantiate AuthVC from Storyboard")
            }
            authVC.delegate = self
            authVC.modalPresentationStyle = .fullScreen
            present(authVC, animated: true)
            
            Constants.splashScreenFirstTimeAppeared = false
        }
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarViewControllerStoryboardId)
        
        window.rootViewController = tabBarController
    }
    
    //MARK: - Networking methods
    func fetchProfile(token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { fatalError("Unexpectedly found nil while trying to unwrap profile's username")}
                self.fetchProfileImage(username: username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert()
                break
            }
        }
        
    }
    
    func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkErrorAlert()
            }
        }
    }
    //MARK: - Alert
    func showNetworkErrorAlert() {
        let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти  в систему", buttonText: "ОК")
        alertPresenter.showAlert(alertModel)
    }
}
//MARK: - AuthViewControllerDelegate method
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true)
        authService.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let accessToken):
                self.tokenStorage.token = accessToken
                self.fetchProfile(token: self.tokenStorage.token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert()
                print("Failed to fetch token")
            }
        }
    }
}
