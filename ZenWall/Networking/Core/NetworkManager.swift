//
//  NetworkManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Codable>(
        url: String,
        model: T.Type,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (T?, String?) -> Void
    ) {
        
        NetworkingHelper.shared.withHeaders { headers in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                headers: headers
            )
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
}
