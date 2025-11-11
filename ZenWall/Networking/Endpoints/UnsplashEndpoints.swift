//
//  UnsplashEndpoints.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

enum UnsplashEndpoint {
    case random(count: Int)
    case search(query: String, page: Int)
    case topics
    case topicPhotos(slug: String, page: Int)
    
    var path: String {
        switch self {
        case .random(let count):
            return NetworkingHelper.shared.configureURL(endpoint: "photos/random?count=\(count)")
            
        case .search(let query, let page):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            return NetworkingHelper.shared.configureURL(endpoint: "search/photos?query=\(encodedQuery)&page=\(page)&per_page=20")
            
        case .topics:
            return NetworkingHelper.shared.configureURL(endpoint: "topics")
            
        case .topicPhotos(let slug, let page):
            return NetworkingHelper.shared.configureURL(endpoint: "topics/\(slug)/photos?page=\(page)&per_page=20")
        }
    }
}
