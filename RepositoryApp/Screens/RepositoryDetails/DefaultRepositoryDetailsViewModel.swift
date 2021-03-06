//
//  RepositoryDetailsViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import Foundation
import UIKit

//MARK: RepositorySearchViewModelInterface
protocol RepositoryDetailsViewModel: AnyObject {
    var coordinator: RepositoryDetailsCoordinator { get }
    func getRepositoryDetails()
    func openUrl()
    
    func updateStarBtnIsSelected() -> Bool
    func starBtnTapped(isSelected: Bool)
    
    var repositoryDetailsDidLoad: ((_ repository: Repository) -> Void)? { get set }
    var updateStarBtn: (() -> Void)? { get set }

}

class DefaultRepositoryDetailsViewModel {
    
    //MARK: Variables
    var coordinator: RepositoryDetailsCoordinator
    private var repoOwnerFullName: String
    private var repositoryDetailsUseCase: RepositoryDetailsUseCase
    private var repository: Repository?
    
    var repositoryDetailsDidLoad: ((_ repository: Repository) -> Void)?
    var updateStarBtn: (() -> Void)?
    
    
    //MARK: Init
    init(coordinator: RepositoryDetailsCoordinator,
         repoOwnerFullName: String,
         repositoryDetailsUseCase: RepositoryDetailsUseCase) {
        self.coordinator = coordinator
        self.repoOwnerFullName = repoOwnerFullName
        self.repositoryDetailsUseCase = repositoryDetailsUseCase
    }
}

extension DefaultRepositoryDetailsViewModel: RepositoryDetailsViewModel {
    func openUrl() {
        guard let url = URL(string: repository?.url ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    func getRepositoryDetails() {
        repositoryDetailsUseCase.getRepositoryDetails(fullName: repoOwnerFullName)  { [weak self] response in
            switch response {
            case .success(let repository):
                DispatchQueue.main.sync {
                    self?.repository = repository
                    self?.updateStarBtn?()
                    self?.repositoryDetailsDidLoad?(repository)
                }
            case .failure(let error):
                DispatchQueue.main.sync {
                    self?.coordinator.showAlert(title: "Something went wrong", text: error.localizedDescription)
                }
            }
        }
    }
    
    func updateStarBtnIsSelected() -> Bool {
        guard let repository = repository else { return false }
        let fetchedRepositories = RepositoryEntity.fetchRepositories()
        
        return fetchedRepositories.contains(where: {$0.id == repository.id })
    }
    
    func starBtnTapped(isSelected: Bool) {
        guard let repository = repository else { return }
        isSelected ? deleteRepository(repo: repository) : saveRepository(repo: repository)
    }
    
    private func saveRepository(repo: Repository) {
        RepositoryEntity.saveObject(repo: repo) {
            updateStarBtn?()
        } onFailure: { error in
            coordinator.showAlert(title: "", text: error)
        }
    }
    
    private func deleteRepository(repo: Repository) {
        RepositoryEntity.deleteRepository(repo: repo) {
            updateStarBtn?()
        } onFailure: { error in
            coordinator.showAlert(title: "", text: error)
        }
    }
}
