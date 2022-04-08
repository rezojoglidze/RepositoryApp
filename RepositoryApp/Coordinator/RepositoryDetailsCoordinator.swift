//
//  RepositoryDetailsCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 08.04.22.
//

import UIKit

class RepositoryDetailsCoordinator: Coordinator {
    
    deinit {
        print("\(String(describing: RepositoryDetailsCoordinator.self)) deinitialized")
    }
    
    weak var parentCoordinator: Coordinator? //retain cicly avoid because main coordinator olready owns the child.

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private var fullName: String
    
    init(navigationController: UINavigationController,
         fullName: String) {
        self.navigationController = navigationController
        self.fullName = fullName
    }
    
    func start() {
        showRepositoryDetailsView()
    }
    
    func showRepositoryDetailsView() {
        let viewController = RepositoryDetailsViewController.instantiate()
        let viewModel = RepositoryDetailsViewModel(view: viewController, coordinator: self, repoOwnerFullName: fullName, repositoryDetailsUseCase: DefaultRepositoryDetailsUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
