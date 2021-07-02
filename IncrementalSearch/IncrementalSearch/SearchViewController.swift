//
//  SearchViewController.swift
//  IncrementalSearch
//
//  Created by Fangwei Hsu on 2021/07/02.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

// MARK: Private Methods
private extension SearchViewController {
    func setupNavigationBar() {
        self.title = "検索"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Githubを検索"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

// MARK: UISearchBarDelegate Methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
}

// MARK: UITableViewDataSource Methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}
