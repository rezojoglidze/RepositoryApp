//
//  RepositoryCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import UIKit

class RepositorySearchCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self //way to ask nav controller to tell us whenever view contoller has shown by making our main coodinator its delegate. now, we can detect when viewcontroller is shown.
        showRepositorySearchView()
    }
    
    func showRepositorySearchView() {
        let viewController = RepositorySearchViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let viewModel = RepositorySearchViewModel(view: viewController, coordinator: self, repositorySearchUseCase: DefaultRepositorySearchUseCase.shared)
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
