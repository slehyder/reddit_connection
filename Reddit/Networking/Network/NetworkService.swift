//
//  NetworkService.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import Alamofire

protocol IEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

enum ErrorModel: Error, CustomStringConvertible {
    case request
    case network(Error)
    case parse(Error)
    case server(description: String)
    case localData(Error)
    
    var description: String {
        switch self {
        case .network(let error), .parse(let error), .localData(let error):
            return error.localizedDescription
        case .request:
            return "Error request"
        case .server(let description):
            return description
        }
    }
}


class NetworkService {
    static let share = NetworkService()
    
    private var dataRequest: DataRequest?
    private let baseUrl = "https://www.reddit.com/"
    
    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = ["Content-Type":"application/json"])
    -> DataRequest {
        return Alamofire.Session.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }

    func request<T: IEndpoint, D: Codable>(endpoint: T, decodeType: D.Type, completion: @escaping (Swift.Result<D?, ErrorModel>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = self.baseUrl + endpoint.path
            self.dataRequest = self._dataRequest(url: url,
                                                 method: endpoint.method,
                                                 parameters: endpoint.parameter,
                                                 encoding: endpoint.encoding,
                                                 headers: endpoint.header)
            self.dataRequest?.validate()
            
            self.dataRequest?.responseDecodable(of: decodeType) { (response) in
                switch response.result {
                case .success(let responseData):
                    
                    completion(.success(responseData))
                    
                case .failure(let error):
                    print("===> error", error)
                    completion(.failure(ErrorModel.server(description: error.errorDescription ?? "no")))
                }
            }
        }
    }

    func cancelRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.cancel()
        completion?()
    }
    
    func cancelAllRequest(_ completion: (()->Void)? = nil) {
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
