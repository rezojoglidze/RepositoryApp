//
//  Coordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func showAlert(title: String, text: String)
}

extension Coordinator {
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(alertAction)
        guard let presentedViewController = navigationController.visibleViewController else { return }
        presentedViewController.present(alert, animated: true, completion: nil)
    }
}
