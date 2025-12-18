//
//  UnsplashConfig.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 18.12.25.
//

import Foundation

final class UnsplashConfig {
    
    static let shared = UnsplashConfig()
    private init() {}
    
    private let keychainKey = "unsplash_access_key"
    
    private var cachedKey: String?
    private var isFetching = false
    private var waiters: [(String) -> Void] = []
    
    func withAccessKey(
        completion: @escaping (String) -> Void
    ) {
        
        if let cachedKey {
            completion(cachedKey)
            return
        }
        
        if let key = KeychainManager.shared.get(key: keychainKey) {
            cachedKey = key
            completion(key)
            return
        }
        
        waiters.append(completion)
        if isFetching { return }
        
        isFetching = true
        
        FirebaseAdapter.shared.fetchAccessKey { [weak self] key, error in
            guard let self else { return }
            
            self.isFetching = false
            
            guard
                let key,
                error == nil
            else {
                self.waiters.removeAll()
                return
            }
            
            self.cachedKey = key
            KeychainManager.shared.save(key: self.keychainKey, value: key)
            
            let callbacks = self.waiters
            self.waiters.removeAll()
            callbacks.forEach { $0(key) }
        }
    }
}
