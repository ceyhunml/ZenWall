//
//  SearchPhotosManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

final class SearchPhotosManager: SearchPhotosUseCase {
    
    private let manager = NetworkManager.shared
    
    func searchPhotos(query: String, page: Int) async throws -> SearchResponse {
        
        try await manager.request(
            url: UnsplashEndpoint.search(query: query, page: page).path
        )
    }
}
