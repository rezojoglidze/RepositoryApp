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

    @NSManaged public var dateCreated: String?
    @NSManaged public var fullName: String?
    @NSManaged public var language: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var id: Int64
    @NSManaged public var owner: NSSet?

}

// MARK: Generated accessors for owner
extension RepositoryEntity {

    @objc(addOwnerObject:)
    @NSManaged public func addToOwner(_ value: OwnerEntity)

    @objc(removeOwnerObject:)
    @NSManaged public func removeFromOwner(_ value: OwnerEntity)

    @objc(addOwner:)
    @NSManaged public func addToOwner(_ values: NSSet)

    @objc(removeOwner:)
    @NSManaged public func removeFromOwner(_ values: NSSet)

}

extension RepositoryEntity : Identifiable {

}
