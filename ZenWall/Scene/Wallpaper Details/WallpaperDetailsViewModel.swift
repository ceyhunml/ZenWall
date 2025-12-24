//
//  WallpaperDetailsViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import Foundation
import UIKit
import Photos

final class WallpaperDetailsViewModel {
    
    let imageURL: Urls?
    private let photoId: String
    
    var onImageURL: ((String?) -> Void)?
    var onFavoriteChanged: ((Bool) -> Void)?
    
    var isFavorite = false
    
    init(photo: UnsplashPhoto) {
        self.imageURL = photo.urls
        self.photoId = photo.id ?? ""
    }
    
    func loadImage() {
        onImageURL?(imageURL?.full)
        isFavorite = isFavorite(id: photoId)
        onFavoriteChanged?(isFavorite)
    }
    
    func isFavorite(id: String) -> Bool {
        FavoritesManager.shared.isFavorite(id: id)
    }
    
    func toggleFavorite() {
        FavoritesManager.shared.toggleFavorite(id: photoId) { [weak self] newState in
            guard let self else { return }
            self.isFavorite = newState
            self.onFavoriteChanged?(newState)
        }
    }
}
