//
//  StarredRepositoryCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class StarredRepositoryCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator? //retain cicly avoid because main coordinator olready owns the child.

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showStarredRepositoryView()
    }
    
    func showStarredRepositoryView() {
        let viewController = RepositorySearchViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let viewModel = RepositorySearchViewModel(view: viewController, starredRepoCoordinator: self, starredRepositoryUseCase: DefaultStarredRepositoryUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }
}
