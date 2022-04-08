//
//  OwnerEntity+CoreDataProperties.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 08.04.22.
//
//

import Foundation
import CoreData


extension OwnerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OwnerEntity> {
        return NSFetchRequest<OwnerEntity>(entityName: "OwnerEntity")
    }

    @NSManaged public var ownerName: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var repository: RepositoryEntity?

}

extension OwnerEntity : Identifiable {

}
