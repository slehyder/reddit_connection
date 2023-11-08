//
//  SearchEndpoints.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import Alamofire

enum SearchEndpoints {
    case search(query: String?, after: String?)
    case feed(after: String?)
}

extension SearchEndpoints: IEndpoint {
    var method: HTTPMethod {
        switch self{
        case .search, .feed:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(let query, let after):
            return "r/chile/search.json?limit=\(Constants.Search.limitForPage)\(query != nil ? "&q=\(query!)" : "")\(after != nil ? "&after=\(after!)" : "")"
        case .feed(let after):
            return "r/chile/new/.json?limit=\(Constants.Search.limitForPage)\(after != nil ? "&after=\(after!)" : "")"
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .search, .feed:
            return nil
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        case .search, .feed:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

