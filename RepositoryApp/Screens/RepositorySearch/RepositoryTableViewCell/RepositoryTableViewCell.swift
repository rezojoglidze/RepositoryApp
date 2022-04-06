//
//  RepositoryTableViewCell.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImg: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var repositoryName: UILabel!
    
    func fill(username: String, repositoryName: String, imageUrl: String) {
        self.username.text = username
        self.repositoryName.text = repositoryName
        self.avatarImg.contentMode = .scaleToFill
        getImage(imageUrl: imageUrl)
    }
    
    private func getImage(imageUrl: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: imageUrl) else { return }
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.avatarImg.image = UIImage(data: data)
                }
            }
        }
    }
}
