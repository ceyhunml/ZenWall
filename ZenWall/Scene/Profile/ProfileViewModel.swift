//
//  ProfileViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.12.25.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Outputs
    var username: String = "Aria"
    var avatarURL: String = ""
    
    // MARK: - Sign Out
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserSessionManager.shared.logout()
    }
}
