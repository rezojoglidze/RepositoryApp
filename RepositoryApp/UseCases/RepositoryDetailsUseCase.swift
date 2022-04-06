//
//  RepositoryDetailsUseCase.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import Foundation

protocol RepositoryDetailsUseCase {
    func getRepositoryDetails(fullName: String, completionHandler: @escaping (Result<Repository, Error>) -> Void)
}

final class DefaultRepositoryDetailsUseCase {
    static let shared: RepositoryDetailsUseCase = DefaultRepositoryDetailsUseCase()
    private enum Constants {
        static let endPoint = "https://api.github.com/repos"
    }
    private init() { }
}

extension DefaultRepositoryDetailsUseCase: RepositoryDetailsUseCase {
    func getRepositoryDetails(fullName: String, completionHandler: @escaping (Result<Repository, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.endPoint)/\(fullName)") else { return }
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
             
                do {
                    let repository = try jsonDecoder.decode(Repository.self, from: data)
                    completionHandler(.success(repository))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
