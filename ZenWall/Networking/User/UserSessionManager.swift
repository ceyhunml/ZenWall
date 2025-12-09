//
//  UserSessionManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 03.12.25.
//

import Foundation

final class UserSessionManager {
    
    static let shared = UserSessionManager()
    private init() {}
    
    private let key = "isLoggedIn"
    
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    func logout() {
        isLoggedIn = false
    }
}
