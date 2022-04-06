//
//  Repository.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import Foundation

struct Repository: Codable {
    let fullName: String?
    let owner: Owner?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case owner
    }
}

struct Owner: Codable {
    let ownerName: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case ownerName = "login"
        case avatarUrl = "avatar_url"
    }
}
