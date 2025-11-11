//
//  HomeViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    private(set) var photos = [UnsplashPhoto]()
    private let randomPhotosManager = RandomPhotosManager()
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func fetchRandomPhotos(count: Int = 20) {
        randomPhotosManager.getRandomPhotos(count: count) { [weak self] data, error in
            guard let self = self else { return }
            
            if let data {
                self.photos = data
                self.success?()
            } else {
                self.error?(error ?? "Unknown error")
            }
        }
    }
}
