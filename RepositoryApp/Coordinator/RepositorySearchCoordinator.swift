//
//  RepositoryCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import UIKit

class RepositorySearchCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator? //retain cicly avoid because main coordinator olready owns the child.
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRepositorySearchView()
    }
    
    func showRepositorySearchView() {
        let viewController = RepositorySearchViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let viewModel = RepositorySearchViewModel(view: viewController, repoSearchCoordinator: self, repositorySearchUseCase: DefaultRepositorySearchUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
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
