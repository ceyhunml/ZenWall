//
//  KeychainManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 18.12.25.
//

import Security
import Foundation

final class KeychainManager {
    
    static let shared = KeychainManager()
    private init() {}
    
    func save(key: String, value: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        
        guard
            status == errSecSuccess,
            let data = dataRef as? Data
        else { return nil }
        
        return String(decoding: data, as: UTF8.self)
    }
}
