//
//  AccessKeyService.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 18.12.25.
//

import Foundation

final class AccessKeyService {
    
    static let shared = AccessKeyService()
    private init() {}
    
    private let keychainKey = "unsplash_access_key"
    
    func getAccessKey(completion: @escaping (String?, String?) -> Void) {
        
        if let cachedKey = KeychainManager.shared.get(key: keychainKey) {
            completion(cachedKey, nil)
            return
        }
        
        FirebaseAdapter.shared.fetchAccessKey { key, error in
            if let error {
                completion(nil, error)
                return
            }
            
            guard let key else {
                completion(nil, "Access key missing")
                return
            }
            
            KeychainManager.shared.save(
                key: self.keychainKey,
                value: key
            )
            
            completion(key, nil)
        }
    }
}
