//
//  StarredRepositoryViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import Foundation
import UIKit

//MARK: RepositorySearchViewModelInterface
protocol StarredRepositoryViewModel: AnyObject {
    
    func fetchRepositories()
    func numberOfRowsInSection() -> Int
    func getRepository(with indexPath: IndexPath) -> RepositoryEntity
    func didSelectRowAt(at indexPath: IndexPath)
    
    var repositoriesLoaded: (() -> Void)? { get set }
}

class DefaultStarredRepositoryViewModel {
    
    //MARK: Variables
    private var coordinator: StarredRepositoryCoordinator
    private var starredRepositoryUseCase: StarredRepositoryUseCase
    
    private var repositories: [RepositoryEntity] = []

    var repositoriesLoaded: (() -> Void)?

    //MARK: Repository Search View Init
    
    init(coordinator: StarredRepositoryCoordinator,
         starredRepositoryUseCase: StarredRepositoryUseCase) {
        self.coordinator = coordinator
        self.starredRepositoryUseCase = starredRepositoryUseCase
    }
}

//MARK: RepositorySearchViewModelInterface
extension DefaultStarredRepositoryViewModel: StarredRepositoryViewModel {
    func numberOfRowsInSection() -> Int {
        repositories.count
    }
    
    func getRepository(with indexPath: IndexPath) -> RepositoryEntity {
        return repositories[indexPath.row]
    }
    
    func fetchRepositories() {
        self.repositories = RepositoryEntity.fetchRepositories()
        repositoriesLoaded?()
    }
    
    func didSelectRowAt(at indexPath: IndexPath) {
        if let ownerFullName = repositories[indexPath.row].fullName {
            coordinator.showRepositoryDetailsView(fullName: ownerFullName)
        }
    }
}
