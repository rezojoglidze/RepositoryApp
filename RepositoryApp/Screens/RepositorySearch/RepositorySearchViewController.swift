//
//  RepositorySearch.swift
//  RepositoryApp
//
//  Created by Rezo Joglidze on 05.04.22.
//

import UIKit

//MARK: RepositorySearchViewInterface
protocol RepositorySearchViewInterface: AnyObject {
    func repositoriesDidLoad(repositories: [Repository])
}

class RepositorySearchViewController: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    private let searchController = UISearchController()
    private var repositories: [Repository] = []
    private var isPaging = false
    private var pageNumberIsNeededReload = false

    var viewModel: RepositorySearchViewModelInterface!

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
    }
    
    //MARK: Functions
    private func setupView() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoryTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func searchRepositories(pagination: Bool, name: String) {
        viewModel.searchRepositories(pagination: isPaging, name: name, reload: pageNumberIsNeededReload)
    }
}

//MARK: RepositorySearchViewInterface
extension RepositorySearchViewController: RepositorySearchViewInterface {
    func repositoriesDidLoad(repositories: [Repository]) {
        if pageNumberIsNeededReload {
            self.repositories = repositories
            tableView.reloadData()
            pageNumberIsNeededReload = false
            return
        }
        
        if repositories.isEmpty {
            self.tableView.tableFooterView = nil
            isPaging = false
        } else {
            isPaging = true
            self.repositories.append(contentsOf: repositories)
            tableView.reloadData()
            self.tableView.tableFooterView = nil
        }
    }
}

extension RepositorySearchViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self)) as? RepositoryTableViewCell
        let repo = repositories[indexPath.row]
        cell?.fill(username: repo.owner?.ownerName ?? "", repositoryName: repo.fullName ?? "", imageUrl: repo.owner?.avatarUrl ?? "")
        return cell ?? UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > tableView.contentSize.height - tableView.frame.size.height
            && isPaging {
//            isPaging = true
            
            if let text = searchController.searchBar.text?.removeWhitespace().lowercased() {
                if !text.isEmpty {
                    self.tableView.tableFooterView = createSpinnerFooter()
                    searchRepositories(pagination: true, name: text)
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
            searchRepositories(pagination: false, name: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pageNumberIsNeededReload = true
    }
}
