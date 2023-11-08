//
//  SearchService.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

struct SearchService {
    
    static func getFeed(request: SearchModel.Get.Request, completion: @escaping(Result<SearchModel.Get.Response?, ErrorModel>) -> Void) {
        NetworkService.share.request(endpoint: SearchEndpoints.feed(after: request.after), decodeType: SearchModel.Get.Response.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
    
    static func getSearch(request: SearchModel.Get.Request, completion: @escaping(Result<SearchModel.Get.Response?, ErrorModel>) -> Void) {
        NetworkService.share.request(endpoint: SearchEndpoints.search(query: request.query, after: request.after), decodeType: SearchModel.Get.Response.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
}
