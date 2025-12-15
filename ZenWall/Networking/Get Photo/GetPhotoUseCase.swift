//
//  GetPhotoUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 15.12.25.
//

import Foundation

protocol GetPhotoUseCase {
    func getPhoto(id: String, completion: @escaping (UnsplashPhoto?, String?) -> Void)
}
