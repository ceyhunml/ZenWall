//
//  WallpaperDetailsViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import Foundation
import UIKit

final class WallpaperDetailsViewModel {
    
    // MARK: - Properties
    private let photo: UnsplashPhoto
    var onImageLoaded: ((UIImage?) -> Void)?
    
    var descriptionText: String? { photo.description ?? photo.altDescription }
    var authorName: String? { photo.user?.name ?? "Unknown Author" }
    
    // MARK: - Init
    init(photo: UnsplashPhoto) {
        self.photo = photo
    }
    
    // MARK: - Image Fetch
    func fetchImage() {
        guard let urlString = photo.urls?.regular,
              let url = URL(string: urlString) else {
            onImageLoaded?(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            var image: UIImage? = nil
            
            if let data, let img = UIImage(data: data) {
                image = img
            }
            
            DispatchQueue.main.async {
                self.onImageLoaded?(image)
            }
        }.resume()
    }
}
