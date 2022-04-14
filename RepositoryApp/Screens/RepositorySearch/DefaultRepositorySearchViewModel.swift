//
//  RepositorySearchViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation

//MARK: RepositorySearchViewModelInterface
protocol RepositorySearchViewModel: AnyObject {
    
    var isRepositoryUsernameChanged: Bool { get set }
    var isPaginationInProcess: Bool { get set }
    var isReachedMaxPagingIndex: Bool { get set }
    
    func searchRepositories(name: String)
    
    func numberOfRowsInSection() -> Int
    func itemForRowAt(with indexPath: IndexPath) -> Repository
    func didSelectRowAt(at indexPath: IndexPath)
    
    var repositoriesLoaded: ((_ repositories: [Repository]) -> Void)? { get set }
}

class DefaultRepositorySearchViewModel {
    
    //MARK: Variables
    private var coordinator: RepositorySearchCoordinator?
    private var repositorySearchUseCase: RepositorySearchUseCase?
    
    var isRepositoryUsernameChanged = false
    var isPaginationInProcess = false
    var isReachedMaxPagingIndex = false

    private var repositories: [Repository] = []
    
    var repositoriesLoaded: ((_ repositories: [Repository]) -> Void)?

    //MARK: Repository Search View Init
    init(coordinator: RepositorySearchCoordinator,
         repositorySearchUseCase: RepositorySearchUseCase) {
        self.coordinator = coordinator
        self.repositorySearchUseCase = repositorySearchUseCase
    }
}

//MARK: RepositorySearchViewModelInterface
extension DefaultRepositorySearchViewModel: RepositorySearchViewModel {
    func numberOfRowsInSection() -> Int {
        repositories.count
    }
    
    func itemForRowAt(with indexPath: IndexPath) -> Repository {
        return repositories[indexPath.row]
    }
    
    
    func didSelectRowAt(at indexPath: IndexPath) {
        let repo = repositories[indexPath.row]
        coordinator?.showRepositoryDetailsView(fullName: repo.fullName)
    }
    
    func searchRepositories(name: String) {
        repositorySearchUseCase?.searchRepository(isPaginating: isPaginationInProcess, name: name, reload: isRepositoryUsernameChanged) { [weak self] response in
            switch response {
            case .success(let repositories):
                    self?.repositoriesDidLoad(repositories: repositories)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.coordinator?.showAlert(title: "Something went wrong", text: error.localizedDescription)
                    self?.returnValuesInPreviousState()
                }
            }
        }
    }
    
    private func repositoriesDidLoad(repositories: [Repository]) {
        if isRepositoryUsernameChanged {
            self.repositories = repositories
            isRepositoryUsernameChanged = false
            DispatchQueue.main.async {
                self.repositoriesLoaded?(repositories)
            }
            return
        }
        
        if repositories.isEmpty {
            isReachedMaxPagingIndex = true
        } else {
            self.repositories.append(contentsOf: repositories)
        }
        isPaginationInProcess = false
        DispatchQueue.main.async {
            self.repositoriesLoaded?(repositories)
        }
    }
    
    private func returnValuesInPreviousState() {
        if isRepositoryUsernameChanged {
            isRepositoryUsernameChanged = false
        }
        isPaginationInProcess = false
    }
}
