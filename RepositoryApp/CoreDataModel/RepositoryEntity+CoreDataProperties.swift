//
//  RepositoryEntity+CoreDataProperties.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 11.04.22.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var dateCreated: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: Int64
    @NSManaged public var language: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var owner: OwnerEntity?

}

extension RepositoryEntity : Identifiable {

}
