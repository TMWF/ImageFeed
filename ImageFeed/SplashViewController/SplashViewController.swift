//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 27.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (!OAuth2TokenStorage().token.isEmpty) {
            print("Switching inside viewDidAppear")
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: Constants.showAuthScreenSegueIdentifier, sender: nil)
        }
        super.viewDidAppear(animated)
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
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true)
        OAuth2Service().fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                self.switchToTabBarController()
            case .failure:
//                let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти  в систему", buttonText: "ОК")
//                self.alertPresenter.showAlert(alertModel)
                print("Failed to fetch token")
            }
        }
    }
}
