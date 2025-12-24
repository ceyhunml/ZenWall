//
//  ListViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 14.11.25.
//

import Foundation

final class ListViewModel {

    // MARK: - Properties
    var photos: [UnsplashPhoto] = []
    var selectedTopic: String
    var selectedTopicForUI: String
    var currentPage = 1
    
    init (selectedTopic: String, selectedTopicForUI: String) {
        self.selectedTopic = selectedTopic
        self.selectedTopicForUI = selectedTopicForUI
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    private let manager = TopicsManager()
    private let favoritesManager = FavoritesManager.shared
    
    func fetchImages(page: Int = 1) {
        manager.getTopicPhotos(topicSlug: selectedTopic, page: page) { data, error in
            if let error {
                self.error?(error)
            } else if let data {
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func isFavorite(photoId: String) -> Bool {
        favoritesManager.isFavorite(id: photoId)
    }
    
    func toggleFavorite(
        photoId: String,
        completion: @escaping (Bool) -> Void
    ) {
        favoritesManager.toggleFavorite(id: photoId) { _ in
            completion(true)
        }
    }
    
    //MARK: - Pagination
    func pagination(index: Int) {
        guard index == photos.count - 2 else { return }
        currentPage += 1
        fetchImages(page: currentPage)
    }
    
    //MARK: - Refresh
    func refresh() {
        currentPage = 1
        photos.removeAll()
        fetchImages()
    }
}
