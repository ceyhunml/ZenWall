//
//  NetworkingHelper.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import Alamofire

final class NetworkingHelper {
    
    private let baseURL = "https://api.unsplash.com"
    
    let headers: HTTPHeaders = [
        "Authorization": "Client-ID YOUR_ACCESS_KEY",
        "Accept-Version": "v1"
    ]
    
    static let shared = NetworkingHelper()
    private init() {}
    
    func configureURL(endpoint: String) -> String {
        baseURL + endpoint
    }
    
//    func configureImageURL(path: String, ImageSize: ImageSize) -> String {
//        imageBaseURL + ImageSize.rawValue + path
//    }
}
