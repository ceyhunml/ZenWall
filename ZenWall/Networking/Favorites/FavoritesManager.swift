//
//  FavoritesManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import Foundation

final class FavoritesManager: FavoritesUseCase {
    
    static let shared = FavoritesManager()
    
    private let adapter = FirebaseAdapter.shared
    private(set) var favoriteIDs: Set<String> = []
    
    var userId: String? {
        UserSessionManager.shared.userId
    }
    
    init() {}
    
    // MARK: - Fetch
    func getFavoriteIDs(completion: @escaping ([String]) -> Void) {
        guard let userId else { return }
        
        adapter.fetchFavoriteIDs(userId: userId) { [weak self] ids, _ in
            self?.favoriteIDs = Set(ids)
            completion(ids)
        }
    }
    
    // MARK: - Check
    func isFavorite(id: String) -> Bool {
        favoriteIDs.contains(id)
    }
    
    // MARK: - Toggle
    func toggleFavorite(
        id: String,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard let userId else { return }
        
        if favoriteIDs.contains(id) {
            adapter.removeFavorite(userId: userId, favoriteId: id) { [weak self] _ in
                self?.favoriteIDs.remove(id)
                completion?(false)
            }
        } else {
            adapter.addFavorite(userId: userId, favoriteId: id) { [weak self] _ in
                self?.favoriteIDs.insert(id)
                completion?(true)
            }
        }
    }
}
