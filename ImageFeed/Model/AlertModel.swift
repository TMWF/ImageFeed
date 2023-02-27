//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 25.02.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)?
}
