//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 25.02.2023.
//

import UIKit

protocol AlertPresenter {
    var controller: UIViewController? {get set}
    func showAlert(_ alertModel: AlertModel)
}

struct AlertPresenterImplementation: AlertPresenter {
    weak var controller: UIViewController?
    
    func showAlert(_ alertModel: AlertModel) {
        guard let controller else { return }
        
        let alert = UIAlertController(title: alertModel.title,
                                 message: alertModel.message,
                                 preferredStyle: .alert)

        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)

        alert.addAction(action)

        controller.present(alert, animated: true, completion: nil)
    }
}

