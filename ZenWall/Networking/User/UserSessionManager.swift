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
    
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isLoggedIn") }
    }
    
    var userId: String? {
        get { UserDefaults.standard.string(forKey: "userId") }
        set { UserDefaults.standard.set(newValue, forKey: "userId") }
    }
    
    func clearSession() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
}
