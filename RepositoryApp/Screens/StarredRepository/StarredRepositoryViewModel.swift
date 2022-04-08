//
//  StarredRepositoryViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import Foundation
import UIKit

//MARK: RepositorySearchViewModelInterface
protocol StarredRepositoryViewModelInterface: AnyObject {
    var coordinator: StarredRepositoryCoordinator { get }
    
    func fetchRepositories()
    func numberOfRowsInSection() -> Int
    func getRepository(with indexPath: IndexPath) -> RepositoryEntity
}

class StarredRepositoryViewModel {
    
    //MARK: Variables
    weak var view: StarredRepositoryViewInterface?
    var coordinator: StarredRepositoryCoordinator
    private var starredRepositoryUseCase: StarredRepositoryUseCase
    
    private var repositories: [RepositoryEntity] = []
        
    //MARK: Repository Search View Init
    
    init(view: StarredRepositoryViewInterface,
         coordinator: StarredRepositoryCoordinator,
         starredRepositoryUseCase: StarredRepositoryUseCase) {
        self.view = view
        self.coordinator = coordinator
        self.starredRepositoryUseCase = starredRepositoryUseCase
    }
}

//MARK: RepositorySearchViewModelInterface
extension StarredRepositoryViewModel: StarredRepositoryViewModelInterface {
    func numberOfRowsInSection() -> Int {
        repositories.count
    }
    
    func getRepository(with indexPath: IndexPath) -> RepositoryEntity {
        return repositories[indexPath.row]
    }
    
    func fetchRepositories() {
        self.repositories = RepositoryEntity.shared.fetchRepositories()
        view?.repositoriesDidLoad()
    }
}
