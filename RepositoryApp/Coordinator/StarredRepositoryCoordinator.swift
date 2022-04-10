//
//  StarredRepositoryCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class StarredRepositoryCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: Coordinator? //retain cicly avoid because main coordinator olready owns the child.

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showStarredRepositoryView()
    }
    
    func showStarredRepositoryView() {
        let viewController = StarredRepositoryViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let viewModel = StarredRepositoryViewModel(coordinator: self, starredRepositoryUseCase: DefaultStarredRepositoryUseCase.shared)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showRepositoryDetailsView(fullName: String) {
        let repositoryDetailsCoordinator = RepositoryDetailsCoordinator(navigationController: navigationController, fullName: fullName)
        repositoryDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(repositoryDetailsCoordinator)
        repositoryDetailsCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    //This mettod called by delegate when a view contoller has been shown
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewContoller = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewContoller) {
            return
        }
        
        if let repositoryDetailsViewController = fromViewContoller as? RepositoryDetailsViewController {
            childDidFinish(repositoryDetailsViewController.viewModel.coordinator)
        }
    }
}
