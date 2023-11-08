//
//  SearchViewController.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    var searchController : UISearchController!
    
    var emptyView: EmptyStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GlobalSettings.hasShowConfigurationPermissionsViewController {
            goToPermissionsVC()
        }
    }
    
    private func goToPermissionsVC () {
        let vc = PermissionsContainerViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func setupEmptyView(show: Bool) {
        if show {
            if self.emptyView == nil {
                self.emptyView = EmptyStateView(title: Constants.Strings.Controllers.Search.notResults, image: "searchNoFound", message: Constants.Strings.Controllers.Search.noResultMessage)
                self.view.addSubview(self.emptyView)
                self.emptyView.pinEdgesToSuperview()
            }
        } else {
            if self.emptyView != nil {
                self.emptyView.removeFromSuperview()
                self.emptyView = nil
            }
        }
    }
}

extension SearchViewController {
    private func prepareView() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settingIcon")?.resize(newWidth: 30), style: .plain, target: self, action: #selector(onSettingsTapped))
        navigationItem.leftBarButtonItem = settingsButton
        navigationController?.navigationBar.tintColor = .black
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.Strings.Controllers.Search.search
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        tableView.register(cell: SearchTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        connection()
        
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.keyboardDismissMode = .onDrag
     }

     @objc private func refreshData(_ sender: UIRefreshControl) {
         viewModel.after = nil
         viewModel.canLoadMore = true
         viewModel.isLoadingMore = false
         viewModel.redditPosts = []
         if searchController.isActive {
             performSearch()
         }else{
             getFeed()
         }
     }
    
    func connection() {
        getFeed()
        viewModel.$redditPosts
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] newResults in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
                FactoryLoader.removeLoader(inView: strongSelf.view)
                strongSelf.refreshControl.endRefreshing()
                strongSelf.setupEmptyView(show: strongSelf.viewModel.redditPosts.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    @objc func onSettingsTapped() {
        goToPermissionsVC()
    }
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        viewModel.after = nil
        viewModel.redditPosts = []
        viewModel.searchText = nil
        viewModel.canLoadMore = true
        viewModel.isLoadingMore = false
        
        guard let text = searchController.searchBar.text,
              !text.isBlank() else {
            if searchController.isActive {
                performSearch()
            }else{
                getFeed()
            }
            return
        }
        
        viewModel.searchText = text.isBlank() ? nil : text
        viewModel.searchTimer?.invalidate()
        viewModel.limit = false
        viewModel.searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
    
    @objc func performSearch() {
        FactoryLoader.loader(inView: self.view)
        viewModel.performSearch(query: viewModel.searchText)
    }
    
    func getFeed() {
        FactoryLoader.loader(inView: self.view)
        viewModel.getFeed()
    }
}

extension SearchViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.redditPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: SearchTableViewCell.self, for: indexPath)
        cell.post = viewModel.redditPosts[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2.5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.redditPosts.count - 1 {
            if viewModel.isLoadingMore { return }
            if viewModel.canLoadMore {
                if searchController.isActive {
                    performSearch()
                }else{
                    getFeed()
                }
            }
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
