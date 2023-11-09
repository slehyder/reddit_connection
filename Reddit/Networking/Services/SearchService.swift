//
//  SearchService.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

protocol NetworkServiceProvider {
    func request<T: IEndpoint, D: Codable>(endpoint: T, decodeType: D.Type, completion: @escaping (Result<D?, ErrorModel>) -> Void)
}

struct SearchService {
    
    let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider) {
        self.networkService = networkService
    }
    
    func getFeed(request: SearchModel.Get.Request, completion: @escaping(Result<SearchModel.Get.Response?, ErrorModel>) -> Void) {
        networkService.request(endpoint: SearchEndpoints.feed(after: request.after), decodeType: SearchModel.Get.Response.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
    
    func getSearch(request: SearchModel.Get.Request, completion: @escaping(Result<SearchModel.Get.Response?, ErrorModel>) -> Void) {
        networkService.request(endpoint: SearchEndpoints.search(query: request.query, after: request.after), decodeType: SearchModel.Get.Response.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
}
