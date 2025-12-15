//
//  GetPhotoManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 15.12.25.
//

import Foundation

final class GetPhotoManager: GetPhotoUseCase {
    
    private let manager = NetworkManager.shared
    
    func getPhoto(id: String, completion: @escaping (UnsplashPhoto?, String?) -> Void) {
        manager.request(
            url: UnsplashEndpoint.getPhoto(id: id).path,
            model: UnsplashPhoto.self,
            completion: completion
        )
    }
}
