//
//  MainTabBarController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let repoSearch = RepositorySearchCoordinator(navigationController: UINavigationController())
    private let starredRepo = StarredRepositoryCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoSearch.start()
        starredRepo.start()
        viewControllers = [repoSearch.navigationController, starredRepo.navigationController]
    }
}
