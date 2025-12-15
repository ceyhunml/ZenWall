//
//  FavoritesViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import Foundation

final class FavoritesViewModel {
    
    // MARK: - State
    private(set) var favoriteIDs: [String] = []
    private(set) var favoritePhotos: [UnsplashPhoto] = []
    
    // MARK: - Callbacks
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    // MARK: - Managers
    private let favoritesManager = FavoritesManager.shared
    private let photosManager = GetPhotoManager()
    
    // MARK: - Public
    
    func getFavorites() {
        favoritesManager.getFavoriteIDs { [weak self] ids in
            guard let self else { return }
            self.favoriteIDs = ids
            self.loadPhotos()
        }
    }
    
    func toggleFavorite(
        id: String,
        completion: @escaping (Bool) -> Void
    ) {
        favoritesManager.toggleFavorite(id: id) { [weak self] isFavorite in
            guard let self else { return }
            
            if !isFavorite {
                self.favoriteIDs.removeAll { $0 == id }
                self.favoritePhotos.removeAll { $0.id == id }
                self.success?()
            }
            
            completion(true)
        }
    }
    
    func isFavorite(id: String) -> Bool {
        favoritesManager.isFavorite(id: id)
    }
    
    private func loadPhotos() {
        let group = DispatchGroup()
        favoritePhotos.removeAll()
        
        for id in favoriteIDs {
            group.enter()
            
            photosManager.getPhoto(id: id) { [weak self] photo, _ in
                if let photo {
                    self?.favoritePhotos.append(photo)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.success?()
        }
    }
}
