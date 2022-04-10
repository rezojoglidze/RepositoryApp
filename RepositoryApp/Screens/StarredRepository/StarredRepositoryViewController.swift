//
//  StarredRepositoryViewController.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 07.04.22.
//

import UIKit

class StarredRepositoryViewController: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var viewModel: StarredRepositoryViewModelInterface!

    static func instantiate() -> StarredRepositoryViewController {
        let storyBoard = UIStoryboard(name: "StarredRepository", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "StarredRepositoryViewController") as? StarredRepositoryViewController ?? .init()
        return viewController
    }
    
    //MARK: View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRepositories()
    }

    //MARK: Functions
    private func setupView() {
        title = "Saved Repositories"
    }
    
    private func setupObservers() {
        viewModel.repositoriesLoaded = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoryTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate 
extension StarredRepositoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self)) as? RepositoryTableViewCell
        let repo = viewModel.getRepository(with: indexPath)
        cell?.fill(username: repo.owner?.ownerName ?? "", repositoryName: repo.fullName ?? "", imageUrl: repo.owner?.avatarUrl ?? "")
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
    }
}
