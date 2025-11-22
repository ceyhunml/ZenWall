//
//  UIImageExtension.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 21.11.25.
//

import UIKit
import Kingfisher
import Photos

extension UIImage {
    static func downloadAndSave(from urlString: String,
                                completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
                
            case .success(let value):
                let image = value.image
                
                PHPhotoLibrary.requestAuthorization { status in
                    guard status == .authorized else {
                        completion(false)
                        return
                    }
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    completion(true)
                }
                
            case .failure(_):
                completion(false)
            }
        }
    }
}
