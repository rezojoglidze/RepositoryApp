//
//  RepositorySearchViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation

//MARK: RepositorySearchViewModelInterface
protocol RepositorySearchViewModelInterface: AnyObject {
    var coordinator: RepositoryCoordinator { get }
    func searchRepositories(pagination: Bool, name: String, reload: Bool)
}

class RepositorySearchViewModel {
    
    //MARK: Variables
    weak var view: RepositorySearchViewInterface?
    var coordinator: RepositoryCoordinator
    private let repositorySearchUseCase: RepositorySearchUseCase

    //MARK: Init
    init(view: RepositorySearchViewInterface,
         coordinator: RepositoryCoordinator,
         repositorySearchUseCase: RepositorySearchUseCase) {
        self.view = view
        self.coordinator = coordinator
        self.repositorySearchUseCase = repositorySearchUseCase
    }
}

//MARK: RepositorySearchViewModelInterface
extension RepositorySearchViewModel: RepositorySearchViewModelInterface {
    func searchRepositories(pagination: Bool, name: String, reload: Bool) {
        repositorySearchUseCase.searchRepository(isPaginating: pagination, name: name, reload: reload) { [weak self] response in
            switch response {
            case .success(let repositories):
                DispatchQueue.main.sync {
                    self?.view?.repositoriesDidLoad(repositories: repositories)
                }
            case .failure(let error):
                DispatchQueue.main.sync {
                    self?.coordinator.showAlert(title: "Something went wrong", text: error.localizedDescription)
                }
            }
        }
    }
}
