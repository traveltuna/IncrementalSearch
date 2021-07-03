//
//  SearchViewController.swift
//  IncrementalSearch
//
//  Created by Fangwei Hsu on 2021/07/02.
//

import SafariServices
import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.isHidden = true
        }
    }
    private var repositoryViewModel = RepositoryViewModel(items: [Repository]())
    private var isShowingSafariVC = false
    
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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Githubを検索"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func clearData() {
        repositoryViewModel = RepositoryViewModel(items: [Repository]())
        tableView.reloadData()
    }
    
    @objc func fetchSearchResult() {
        guard let query = navigationItem.searchController?.searchBar.text, !query.isEmpty else {
            clearData()
            return
        }
        repositoryViewModel.fetchSearchResults(query: query) { [weak self] model, error in
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            } else if let model = model {
                self?.repositoryViewModel = model
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: UISearchBarDelegate Methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !isShowingSafariVC {
            tableView.isHidden = true
            clearData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchSearchResult), object: nil)
        perform(#selector(fetchSearchResult), with: nil, afterDelay: 0.5)
    }
}

// MARK: UITableViewDataSource Methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = repositoryViewModel.items[indexPath.row].name
        return cell
    }
}

// MARK: UITableViewDelegate Methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isShowingSafariVC = true
        let url = URL(string: repositoryViewModel.items[indexPath.row].htmlUrl)
        if let url = url {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: SFSafariViewControllerDelegate Methods
extension SearchViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        isShowingSafariVC = false
    }
}
