//
//  RepositorySearch.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import UIKit

class RepositorySearchViewController: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: Variables
    private let searchController = UISearchController()

    var viewModel: RepositorySearchViewModel!

    static func instantiate() -> RepositorySearchViewController {
        let storyBoard = UIStoryboard(name: "RepositorySearch", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RepositorySearchViewController") as? RepositorySearchViewController ?? .init()
        return viewController
    }
    
    //MARK: View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupSearchController()
        setupObservers()
    }

    //MARK: Functions
    private func setupView() {
        title = "Repositories"
    }
    
    private func setupObservers() {
        viewModel.repositoriesLoaded = { [weak self] repositories in
            if self?.viewModel.isRepositoryUsernameChanged == true {
                self?.tableView.reloadData()
                return
            }
            
            if repositories.isEmpty {
                self?.tableView.tableFooterView = nil
            } else {
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
        }
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoryTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate
extension RepositorySearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self)) as? RepositoryTableViewCell
        let repo = viewModel.getRepository(with: indexPath)
        cell?.fill(username: repo.owner.ownerName, repositoryName: repo.fullName, imageUrl: repo.owner.avatarUrl)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
    }
}

//MARK: UIScrollViewDelegate
extension RepositorySearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > tableView.contentSize.height - tableView.frame.size.height
            && !viewModel.isPaginationInProcess && !viewModel.isReachedMaxPagingIndex {
            
            if let text = searchController.searchBar.text?.removeWhitespace().lowercased() {
                if !text.isEmpty {
                    self.tableView.tableFooterView = createSpinnerFooter()
                    viewModel.isPaginationInProcess = true
                    viewModel.searchRepositories(name: text)
                }
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

//MARK: UISearchControllerDelegate
extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchController.searchBar.text?.removeWhitespace().lowercased() {
            viewModel.searchRepositories(name: text)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isRepositoryUsernameChanged = true
        viewModel.isReachedMaxPagingIndex = false
    }
}
