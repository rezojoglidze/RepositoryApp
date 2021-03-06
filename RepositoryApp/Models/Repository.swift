//
//  Repository.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import Foundation

struct Repository: Codable {
    let id: Int64
    let fullName: String
    let owner: Owner
    let dateCreated: String
    let language: String?
    let repoDescription: String?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case dateCreated = "updated_at"
        case language = "language"
        case repoDescription = "description"
        case url = "html_url"
    }
}

struct Owner: Codable {
    let ownerName: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case ownerName = "login"
        case avatarUrl = "avatar_url"
    }
}
