//
//  HomeViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    var photos = [UnsplashPhoto]()
    var currentQuery: String?
    var currentPage = 1
    
    private let randomPhotosManager = RandomPhotosManager()
    private let searchManager = SearchPhotosManager()
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func fetchRandomPhotos(count: Int = 20) {
        randomPhotosManager.getRandomPhotos(count: count) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func searchPhotos(query: String, page: Int = 1) {
        photos.removeAll()
        currentQuery = query
        searchManager.searchPhotos(query: query, page: page) { [weak self] data, error in
            guard let self else { return }
            if let data {
                self.photos.append(contentsOf: data.results ?? [])
                self.success?()
            } else if let error {
                self.error?(error)
            }
        }
    }
    
    func pagination(index: Int) {
        guard index == photos.count - 2 else { return }
        
        if let query = currentQuery, !query.isEmpty {
            let nextPage = currentPage + 1
            searchPhotos(query: query, page: nextPage)
        } else {
            fetchRandomPhotos()
        }
    }
}
