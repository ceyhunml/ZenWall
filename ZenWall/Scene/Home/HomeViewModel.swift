//
//  HomeViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    var photos: [UnsplashPhoto] = []
    var photoOfDay: UnsplashPhoto?
    var currentQuery: String?
    var currentPage = 1
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    private let randomManager = RandomPhotosManager()
    private let searchManager = SearchPhotosManager()
    
    // MARK: - Random Photos
    func fetchRandomPhotos() {
        
        randomManager.getRandomPhotos(count: 20) { [weak self] data, error in
            if let data {
                self?.photos.append(contentsOf: data)
                if ((self?.photoOfDay) == nil) {
                    self?.photoOfDay = data.randomElement()
                }
                self?.success?()
            } else if let error {
                self?.error?(error)
            }
        }
    }
    
     //MARK: - Search Photos
    func searchPhotos(query: String, page: Int = 1) {
        currentQuery = query
        
        searchManager.searchPhotos(query: query, page: page) { [weak self] data, error in
            guard let self else { return }
            
            if let data {
                if page == 1 {
                    self.photos = data.results ?? []
                } else {
                    self.photos.append(contentsOf: data.results ?? [])
                }
                self.currentPage = page
                self.success?()
            } else if let error {
                self.error?(error)
            }
        }
    }
    
    // MARK: - Pagination
    func pagination(index: Int) {
        guard index == photos.count - 2 else { return }
        
        if let query = currentQuery, !query.isEmpty {
            currentPage += 1
            searchPhotos(query: query, page: currentPage)
        } else {
            fetchRandomPhotos()
        }
    }
    
    // MARK: - Refresh
    func refresh() {
        currentQuery = nil
        currentPage = 1
        photos.removeAll()
        fetchRandomPhotos()
    }
}
