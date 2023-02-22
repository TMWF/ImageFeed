//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 22.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewController
            else { fatalError("Failed to prepare for \(Constants.showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        <#code#>
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
    
    
}
