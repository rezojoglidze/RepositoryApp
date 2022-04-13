//
//  RepositoryEntity+CoreDataClass.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 11.04.22.
//
//

import Foundation
import CoreData
import UIKit

protocol RepositoryEntityProtocol {
     func fetchRepositories() -> [RepositoryEntity]
     func saveObject(repo: Repository, onSuccess: () -> Void, onFailure: (_ error: String) -> Void)
     func deleteRepository(repo: Repository, onSuccess: () -> Void, onFailure: (_ error: String) -> Void)
}

@objc(RepositoryEntity)
public class RepositoryEntity: NSManagedObject {
     var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

extension RepositoryEntity: RepositoryEntityProtocol {
    func fetchRepositories() -> [RepositoryEntity] {
        do {
            return try context.fetch(RepositoryEntity.fetchRequest())
        } catch(let error) {
            print("errr: ", error.localizedDescription)
        }
        return []
    }
    
     func saveObject(repo: Repository, onSuccess: () -> Void, onFailure: (_ error: String) -> Void) {

        let repoEntity = RepositoryEntity(context: self.context)
        repoEntity.fullName = repo.fullName
        repoEntity.dateCreated = repo.dateCreated
        repoEntity.url = repo.url
        repoEntity.language = repo.language
        repoEntity.repoDescription = repo.repoDescription
        repoEntity.id = repo.id

        let ownerEntity = OwnerEntity(context: self.context)
        ownerEntity.ownerName = repo.owner.ownerName
        ownerEntity.avatarUrl = repo.owner.avatarUrl

        repoEntity.owner = ownerEntity
        
        do {
            try context.save()
            onSuccess()
        } catch(let error) {
            onFailure("Something Happend. Try again later.")
            print(error.localizedDescription)
        }
    }
    
     func deleteRepository(repo: Repository, onSuccess: () -> Void, onFailure: (_ error: String) -> Void) {
       
        let repositories = fetchRepositories()
        guard let deletableRepo = repositories.first(where: {$0.id == repo.id}) else { return }

        self.context.delete(deletableRepo)
        
        do {
            try context.save()
            onSuccess()
        } catch(let error) {
            onFailure("Something Happens. try again later.")
            print(error.localizedDescription)
        }
    }
}
