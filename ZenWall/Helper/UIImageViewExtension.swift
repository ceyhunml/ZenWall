//
//  UIImageViewExtension.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setUnsplashImage(_ urlString: String?,
                          placeholder: UIImage? = nil) {
        
        guard let urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.25)),
                .cacheOriginalImage,
                .backgroundDecode
            ]
        )
    }
}
