//
//  SearchPhotosManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

final class SearchPhotosManager: SearchPhotosUseCase {
    
    private let manager = NetworkManager()
    
    func searchPhotos(query: String, page: Int, completion: @escaping (SearchResponse?, String?) -> Void) {
        manager.request(
            url: UnsplashEndpoint.search(query: query, page: page).path,
            model: SearchResponse.self,
            completion: completion
        )
    }
}
