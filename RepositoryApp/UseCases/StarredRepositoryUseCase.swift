//
//  StarredRepositoryUseCase.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import Foundation

protocol StarredRepositoryUseCase {

}

final class DefaultStarredRepositoryUseCase {
    static let shared: StarredRepositoryUseCase = DefaultStarredRepositoryUseCase()
    private enum Constants {
        static let endPoint = "https://api.github.com/users"
    }
    private init() { }
    
}

extension DefaultStarredRepositoryUseCase: StarredRepositoryUseCase {
  
}
