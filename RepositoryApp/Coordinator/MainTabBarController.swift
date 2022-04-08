//
//  MainTabBarController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let repoSearch = RepositorySearchCoordinator(navigationController: UINavigationController())
    let starredRepo = StarredRepositoryCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoSearch.start()
        starredRepo.start()
        viewControllers = [repoSearch.navigationController, starredRepo.navigationController]
    }
}
