//
//  RepositoryEntity+CoreDataProperties.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 08.04.22.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var dateCreated: String?
    @NSManaged public var language: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var url: String?

}

extension RepositoryEntity : Identifiable {

}
