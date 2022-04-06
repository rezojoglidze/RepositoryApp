//
//  AppCoordinator.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let repositoryCoordinator = RepositoryCoordinator(navigationController: navigationController)
        childCoordinators.append(repositoryCoordinator)
        repositoryCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
