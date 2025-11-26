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
    var onImageURL: ((String?) -> Void)?
    
    init(photo: UnsplashPhoto) {
        self.imageURL = photo.urls
    }
    
    func loadImage() {
        onImageURL?(imageURL?.full)
    }
}
