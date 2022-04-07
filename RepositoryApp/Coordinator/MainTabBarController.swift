//
//  MainTabBarController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let main = MainCoordinator(navigationController: UINavigationController())
    let starredRepo = StarredRepositoryCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        main.start()
        starredRepo.start()
        viewControllers = [main.navigationController, starredRepo.navigationController]
    }
}
