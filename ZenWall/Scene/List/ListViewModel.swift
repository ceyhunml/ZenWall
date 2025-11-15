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
    var selectedTopic = ""
    var currentPage = 1
    var onPhotoSelected: ((UnsplashPhoto) -> Void)?
    
    init(onPhotoSelected: ((UnsplashPhoto) -> Void)? = nil) {
        self.onPhotoSelected = onPhotoSelected
    }
    
    required init(onPhotoSelected: @escaping ((String) -> Void)) {
        onPhotoSelected(String())
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    private let manager = TopicsManager()
    
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
