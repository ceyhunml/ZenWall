//
//  NetworkManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import Alamofire

enum Endpoint {
    case random(count: Int, query: String?)
    case search(query: String, page: Int)
    case photo(id: String)
    
    var path: String {
        switch self {
        case .random(let count, let query):
            if let query {
                return NetworkingHelper.shared.configureURL(endpoint: "/photos/random?count=\(count)&query=\(query)")
            } else {
                return NetworkingHelper.shared.configureURL(endpoint: "/photos/random?count=\(count)")
            }
            
        case .search(let query, let page):
            return NetworkingHelper.shared.configureURL(endpoint: "/search/photos?page=\(page)&per_page=20&query=\(query)")
            
        case .photo(let id):
            return NetworkingHelper.shared.configureURL(endpoint: "/photos/\(id)")
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Codable>(
        url: String,
        model: T.Type,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        completion: @escaping ((T?, String?) -> Void)
    ) {
        AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: NetworkingHelper.shared.headers
        ).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func request<T: Codable>(
        endpoint: Endpoint,
        model: T.Type,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        completion: @escaping ((T?, String?) -> Void)
    ) {
        let url = endpoint.path
        
        AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: NetworkingHelper.shared.headers
        ).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
