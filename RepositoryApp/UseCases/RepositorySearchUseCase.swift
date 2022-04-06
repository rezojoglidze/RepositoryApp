//
//  RepositorySearchUseCase.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import Foundation

protocol RepositorySearchUseCase {
    func searchRepository(isPaginating: Bool, name: String, reload: Bool,
                          completionHandler: @escaping (Result<[Repository], Error>) -> Void)
}

final class DefaultRepositorySearchUseCase {
    static let shared: RepositorySearchUseCase = DefaultRepositorySearchUseCase()
    private enum Constants {
        static let endPoint = "https://api.github.com/users"
    }
    private init() { }
    
    private var pageNumber = 0
    private var perPage =  10
}

extension DefaultRepositorySearchUseCase: RepositorySearchUseCase {
  
    func searchRepository(isPaginating: Bool, name: String, reload: Bool,
                          completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
        if reload {
            pageNumber = 0
        }
        
        if isPaginating {
            pageNumber += 1
        }
        
        guard let url = URL(string: "\(Constants.endPoint)/\(name)/repos?per_page=\(perPage)&page=\(pageNumber)") else { return }
        print(url)
        
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
             
                do {
                    let repositories = try jsonDecoder.decode([Repository].self, from: data)
                    completionHandler(.success(repositories))
                } catch {
                    self?.pageNumber -= 1
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
