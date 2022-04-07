//
//  AppCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {

}

final class MainCoordinator: NSObject, MainCoordinatorProtocol, UINavigationControllerDelegate {
 
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self //way to ask nav controller to tell us whenever view contoller has shown by making our main coodinator its delegate. now, we can detect when viewcontroller is shown.
        let repositorySearchCoordinator = RepositorySearchCoordinator(navigationController: navigationController)
        repositorySearchCoordinator.parentCoordinator = self
        childCoordinators.append(repositorySearchCoordinator)
        repositorySearchCoordinator.start()
    }
    
    private func startRepositorySearchCoordinator() {
        
    }
    
    private func startStarredRepositoryCoordinator() {
        
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
        
        if let repositorySearchViewController = fromViewContoller as? RepositorySearchViewController {
            childDidFinish(repositorySearchViewController.viewModel.repoSearchCoordinator)
        }
    }
}
