//
//  RepositorySearchViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation

//MARK: RepositorySearchViewModelInterface
protocol RepositorySearchViewModelInterface: AnyObject {
    var repoSearchCoordinator: RepositorySearchCoordinator? { get }
    var starredRepoCoordinator: StarredRepositoryCoordinator? { get }
    var isRepositoryUsernameChanged: Bool { get set }
    var isPaginationInProcess: Bool { get set }
    var isReachedMaxPagingIndex: Bool { get set }
    
    func searchRepositories(name: String)
    
    func numberOfRowsInSection() -> Int
    func getRepository(with indexPath: IndexPath) -> Repository
    func didSelectRowAt(at indexPath: IndexPath)
}

class RepositorySearchViewModel {
    
    //MARK: Variables
    weak var view: RepositorySearchViewInterface?
    var repoSearchCoordinator: RepositorySearchCoordinator?
    private var repositorySearchUseCase: RepositorySearchUseCase?

    var starredRepoCoordinator: StarredRepositoryCoordinator?
    private var starredRepositoryUseCase: StarredRepositoryUseCase?
    
    var isRepositoryUsernameChanged = false
    var isPaginationInProcess = false
    var isReachedMaxPagingIndex = false

    private var repositories: [Repository] = []

    //MARK: Repository Search View Init
    init(view: RepositorySearchViewInterface,
         repoSearchCoordinator: RepositorySearchCoordinator,
         repositorySearchUseCase: RepositorySearchUseCase) {
        self.view = view
        self.repoSearchCoordinator = repoSearchCoordinator
        self.repositorySearchUseCase = repositorySearchUseCase
    }
    
    init(view: RepositorySearchViewInterface,
         starredRepoCoordinator: StarredRepositoryCoordinator,
         starredRepositoryUseCase: StarredRepositoryUseCase) {
        self.view = view
        self.starredRepoCoordinator = starredRepoCoordinator
        self.starredRepositoryUseCase = starredRepositoryUseCase
    }
}

//MARK: RepositorySearchViewModelInterface
extension RepositorySearchViewModel: RepositorySearchViewModelInterface {
    func numberOfRowsInSection() -> Int {
        repositories.count
    }
    
    func getRepository(with indexPath: IndexPath) -> Repository {
        return repositories[indexPath.row]
    }
    
    
    func didSelectRowAt(at indexPath: IndexPath) {
        let repo = repositories[indexPath.row]
        repoSearchCoordinator?.showRepositoryDetailsView(fullName: repo.fullName)
    }
    
    func searchRepositories(name: String) {
        repositorySearchUseCase?.searchRepository(isPaginating: isPaginationInProcess, name: name, reload: isRepositoryUsernameChanged) { [weak self] response in
            switch response {
            case .success(let repositories):
                    self?.repositoriesDidLoad(repositories: repositories)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.repoSearchCoordinator?.showAlert(title: "Something went wrong", text: error.localizedDescription)
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
                self.view?.repositoriesDidLoad(repositories: repositories)
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
            self.view?.repositoriesDidLoad(repositories: repositories)
        }
    }
    
    private func returnValuesInPreviousState() {
        if isRepositoryUsernameChanged {
            isRepositoryUsernameChanged = false
        }
        isPaginationInProcess = false
    }
}
