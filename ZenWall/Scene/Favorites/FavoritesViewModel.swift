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
    
    // MARK: - Private
    
    private func loadPhotos() {
        let group = DispatchGroup()
        
        var orderedPhotos: [String: UnsplashPhoto] = [:]
        favoritePhotos.removeAll()
        
        for id in favoriteIDs {
            group.enter()
            
            photosManager.getPhoto(id: id) { [weak self] photo, error in
                defer { group.leave() }
                
                if let error {
                    self?.error?(error)
                    return
                }
                
                if let photo {
                    orderedPhotos[id] = photo
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            self.favoritePhotos = self.favoriteIDs.compactMap {
                orderedPhotos[$0]
            }
            
            self.success?()
        }
    }
}
