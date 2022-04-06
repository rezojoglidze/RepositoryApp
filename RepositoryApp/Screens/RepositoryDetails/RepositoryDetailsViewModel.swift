//
//  RepositoryDetailsViewModel.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import Foundation
import UIKit

//MARK: RepositorySearchViewModelInterface
protocol RepositoryDetailsViewModelInterface: AnyObject {
    var coordinator: RepositoryCoordinator { get }
    func getRepositoryDetails()
    func openUrl()
}

class RepositoryDetailsViewModel {
    
    //MARK: Variables
    weak var view: RepositoryDetailsViewInterface?
    var coordinator: RepositoryCoordinator
    private var repoOwnerFullName: String
    private var repositoryDetailsUseCase: RepositoryDetailsUseCase
    private var repository: Repository?
    
    
    //MARK: Init
    init(view: RepositoryDetailsViewInterface,
         coordinator: RepositoryCoordinator,
         repoOwnerFullName: String,
         repositoryDetailsUseCase: RepositoryDetailsUseCase) {
        self.view = view
        self.coordinator = coordinator
        self.repoOwnerFullName = repoOwnerFullName
        self.repositoryDetailsUseCase = repositoryDetailsUseCase
    }
}

extension RepositoryDetailsViewModel: RepositoryDetailsViewModelInterface {
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
                    self?.view?.repositoryDetailsDidLoad(repository: repository)
                }
            case .failure(let error):
                DispatchQueue.main.sync {
                    self?.coordinator.showAlert(title: "Something went wrong", text: error.localizedDescription)
                }
            }
        }
    }
}
