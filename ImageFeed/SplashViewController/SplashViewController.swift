//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 27.02.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!OAuth2TokenStorage().token.isEmpty) && Constants.splashScreenFirstTimeAppeared {
            print("Switching inside viewDidAppear")
            switchToTabBarController()
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
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarViewControllerStoryboardId)
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        dismiss(animated: true)
        OAuth2Service().fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                ProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                ProgressHUD.dismiss()
//                let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти  в систему", buttonText: "ОК")
//                self.alertPresenter.showAlert(alertModel)
                print("Failed to fetch token")
            }
        }
    }
}
