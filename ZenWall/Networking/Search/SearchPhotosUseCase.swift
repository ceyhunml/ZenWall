//
//  SearchPhotosUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

protocol SearchPhotosUseCase {
    func searchPhotos(query: String, page: Int) async throws -> SearchResponse
}
