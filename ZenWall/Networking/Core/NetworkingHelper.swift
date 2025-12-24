//
//  NetworkingHelper.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import Alamofire

final class NetworkingHelper {
    
    static let shared = NetworkingHelper()
    private init() {}
    
    private let baseURL = "https://api.unsplash.com/"
    
    func withHeaders(
        completion: @escaping (HTTPHeaders) -> Void
    ) {
        UnsplashConfig.shared.withAccessKey { key in
            completion([
                "Authorization": "Client-ID \(key)"
            ])
        }
    }
    
    func configureURL(endpoint: String) -> String {
        baseURL + endpoint
    }
}
