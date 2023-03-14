//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 27.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let authService: OAuth2ServiceProtocol = OAuth2Service()
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!OAuth2TokenStorage().token.isEmpty) && Constants.splashScreenFirstTimeAppeared {
            print("Switching inside viewDidAppear")
            UIBlockingProgressHUD.show()
            fetchProfile(token: tokenStorage.token)
            Constants.splashScreenFirstTimeAppeared = false
        } else if Constants.splashScreenFirstTimeAppeared {
            print("Segue inside viewDidAppear")
            performSegue(withIdentifier: Constants.showAuthScreenSegueIdentifier, sender: nil)
            Constants.splashScreenFirstTimeAppeared = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showAuthScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(Constants.showAuthScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

private extension SplashViewController {
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarViewControllerStoryboardId)
        
        window.rootViewController = tabBarController
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11] Показать ошибку
                break
            }
        }
        
    }
}

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
//                let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти  в систему", buttonText: "ОК")
//                self.alertPresenter.showAlert(alertModel)
                print("Failed to fetch token")
            }
        }
    }
}
