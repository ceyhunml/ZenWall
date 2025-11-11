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
    
    private let baseURL = "https://api.unsplash.com"
    
    private let accessKey = "Z09rq8KTi5ae-4L0D3sAJ8ygjImt6kxFsd1iVtLBhdI"
    
    var headers: HTTPHeaders {
        ["Authorization": "Client-ID \(accessKey)"]
    }
    
    func configureURL(endpoint: String) -> String {
        baseURL + endpoint
    }
}
