//
//  UIImageExtension.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 21.11.25.
//

import UIKit
import Kingfisher
import Photos

enum ImageSaveResult {
    case success
    case denied
    case invalidURL
    case downloadFailed
    case saveFailed
}

extension UIImage {
    static func downloadAndSave(from urlString: String,
                                completion: @escaping (ImageSaveResult) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.invalidURL)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
                
            case .success(let value):
                let image = value.image
                
                PHPhotoLibrary.requestAuthorization { status in
                    
                    guard status == .authorized else {
                        completion(.denied)
                        return
                    }
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    completion(.success)
                }
                
            case .failure(_):
                completion(.downloadFailed)
            }
        }
    }
}
