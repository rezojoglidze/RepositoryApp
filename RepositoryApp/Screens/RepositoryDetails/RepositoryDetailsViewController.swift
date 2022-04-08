//
//  RepositoryDetailsViewController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import UIKit

protocol RepositoryDetailsViewInterface: AnyObject {
    func repositoryDetailsDidLoad(repository: Repository)
    func updateStarBtn()
}

class RepositoryDetailsViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var dateCreatedLabel: UILabel!
    @IBOutlet private weak var openUrlByBrowserBtn: UIButton!
    
    //MARK: Variables
    var viewModel: RepositoryDetailsViewModelInterface!
    
    static func instantiate() -> RepositoryDetailsViewController {
        let storyBoard = UIStoryboard(name: "RepositoryDetails", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RepositoryDetailsViewController") as? RepositoryDetailsViewController ?? .init()
        return viewController
    }
    
    //MARK: View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getRepositoryDetails()
    }
   
    @objc func starBtnTapped(sender: UIBarButtonItem) {
        if let starBtn = navigationItem.rightBarButtonItem {
            viewModel.starBtnTapped(isSelected: starBtn.isSelected)
        }
    }
    
    //MARK: Functions
    private func updateView(with repository: Repository) {
        descriptionLabel.text = repository.repoDescription
        languageLabel.text = repository.language
        dateCreatedLabel.text = repository.dateCreated
        openUrlByBrowserBtn.setTitle("Open Url".uppercased(), for: .normal)
    }
    
    //MARK: IBAction
    @IBAction func openUrlByBrowserBtnDidTap(_ sender: Any) {
        viewModel.openUrl()
    }
}

//MARK: RepositoryDetailsViewInterface
extension RepositoryDetailsViewController: RepositoryDetailsViewInterface {
    func updateStarBtn() {
        let isSelected = viewModel.checkIfRepoIsAlreadySaved()
        let image = isSelected ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(starBtnTapped))
        self.navigationItem.rightBarButtonItem?.isSelected = isSelected
    }
    
    func repositoryDetailsDidLoad(repository: Repository) {
        updateView(with: repository)
    }
}
