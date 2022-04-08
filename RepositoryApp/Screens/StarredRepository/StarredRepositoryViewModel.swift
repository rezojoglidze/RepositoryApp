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
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: Repository Search View Init
    
    init(view: StarredRepositoryViewInterface,
         coordinator: StarredRepositoryCoordinator,
         starredRepositoryUseCase: StarredRepositoryUseCase) {
        self.view = view
        self.coordinator = coordinator
        self.starredRepositoryUseCase = starredRepositoryUseCase
        saveObject()
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
        do {
            print("Started")
            self.repositories = try self.context.fetch(RepositoryEntity.fetchRequest()) as! [RepositoryEntity]
            print("Endd mgoni")
            DispatchQueue.main.async {
                self.view?.repositoriesDidLoad()
            }
        } catch(let error) {
            print("errr: ", error.localizedDescription)
        }
    }
    
    private func saveObject() {
        //create repo obj
        let repo = RepositoryEntity(context: self.context)
        repo.fullName = "Rezo jogg"
        repo.dateCreated = "gushin"
        repo.url = "ruurrr"
        repo.language = "ENG"
        repo.repoDescription = "Descc ra"
         
        
        //Save the data
        do {
            try context.save()
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        //Re-Fetch Data
        self.fetchRepositories()
    }
}
