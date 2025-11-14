//
//  WallpaperDetailsViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import Foundation
import UIKit

final class WallpaperDetailsViewModel {

    let imageURL: String?
    var onImageURL: ((String?) -> Void)?

    init(photo: UnsplashPhoto) {
        self.imageURL = photo.urls?.regular
    }

    func loadImage() {
        onImageURL?(imageURL)
    }
}
