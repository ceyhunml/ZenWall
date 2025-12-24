//
//  FavoritesUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import Foundation

protocol FavoritesUseCase {
    func getFavoriteIDs(completion: @escaping ([String]) -> Void)
    
    func isFavorite(id: String) -> Bool
    
    func toggleFavorite(id: String, completion: ((Bool) -> Void)?)
}
