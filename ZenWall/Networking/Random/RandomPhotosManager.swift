//
//  RandomPhotosManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

final class RandomPhotosManager: RandomPhotosUseCase {
    
    private let manager = NetworkManager()
    
    func getRandomPhotos(count: Int, completion: @escaping ([UnsplashPhoto]?, String?) -> Void) {
        manager.request(
            url: UnsplashEndpoint.random(count: count).path,
            model: [UnsplashPhoto].self,
            completion: completion
        )
    }
}
