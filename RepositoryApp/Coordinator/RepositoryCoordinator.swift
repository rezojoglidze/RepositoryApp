//
//  RepositoryCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation
import UIKit

class RepositoryCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showRepositorySearchView() {
        let viewController = RepositorySearchViewController.instantiate()
        let viewModel = RepositorySearchViewModel(view: viewController, coordinator: self, repositorySearchUseCase: DefaultRepositorySearchUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showRepositoryDetailsView(fullName: String) {
        let viewController = RepositoryDetailsViewController.instantiate()
        let viewModel = RepositoryDetailsViewModel(view: viewController, coordinator: self, repoOwnerFullName: fullName, repositoryDetailsUseCase: DefaultRepositoryDetailsUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(alertAction)
        guard let presentedViewController = navigationController.visibleViewController else { return }
        presentedViewController.present(alert, animated: true, completion: nil)
    }
}
