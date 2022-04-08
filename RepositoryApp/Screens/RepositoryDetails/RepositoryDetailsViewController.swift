//
//  RepositoryDetailsViewController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 06.04.22.
//

import UIKit

protocol RepositoryDetailsViewInterface: AnyObject {
    func repositoryDetailsDidLoad(repository: Repository)
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
    func repositoryDetailsDidLoad(repository: Repository) {
        updateView(with: repository)
    }
}
