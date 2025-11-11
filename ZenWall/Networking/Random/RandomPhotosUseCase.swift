//
//  RandomPhotosUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

protocol RandomPhotosUseCase {
    func getRandomPhotos(count: Int, completion: @escaping ([UnsplashPhoto]?, String?) -> Void)
}
