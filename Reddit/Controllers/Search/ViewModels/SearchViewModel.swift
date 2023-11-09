//
//  SearchViewModel.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var redditPosts: [RedditPost] = []
    var after: String?
    var searchText : String?
    var searchTimer: Timer?
    var limit = false
    var isLoadingMore = false
    var canLoadMore = true
    
    var searchService = SearchService(networkService: NetworkService())
    
    func performSearch(query: String?) {
        
        guard canLoadMore && !isLoadingMore else { return }

        isLoadingMore = true
        
        let request = SearchModel.Get.Request(after: after, query: query)
        searchService.getSearch(request: request) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.isLoadingMore = false
                switch result {
                case .success(let response):
                    
                    let newPosts = response?.data.children.map { $0.data } ?? []
                    let filterPost = newPosts.filter { post in
                        return post.linkFlairText == Constants.Search.filterLinkFlairText || post.postHint == Constants.Search.filterPostHint
                    }
                    strongSelf.redditPosts.append(contentsOf: filterPost)
                    strongSelf.after = response?.data.after
                    if newPosts.isEmpty {
                        strongSelf.canLoadMore = false
                    }
                    
                case .failure(let error):
                    print(error)
                    strongSelf.canLoadMore = false
                }
            }
        }
    }
    
    func getFeed() {
        
        guard canLoadMore && !isLoadingMore else { return }

        isLoadingMore = true
        
        let request = SearchModel.Get.Request(after: after)
        searchService.getFeed(request: request) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.isLoadingMore = false
                switch result {
                case .success(let response):
                    let newPosts = response?.data.children.map { $0.data } ?? []
                    let filterPost = newPosts.filter { post in
                        return post.linkFlairText == Constants.Search.filterLinkFlairText || post.postHint == Constants.Search.filterPostHint
                    }
                    strongSelf.redditPosts.append(contentsOf: filterPost)
                    strongSelf.after = response?.data.after
                    if newPosts.isEmpty {
                        strongSelf.canLoadMore = false
                    }
                case .failure(let error):
                    print(error)
                    strongSelf.canLoadMore = false
                }
            }
        }
    }
}
