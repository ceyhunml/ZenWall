//
//  ProfileViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.12.25.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Outputs
    var onDataLoaded: ((String, String, String?) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Sign Out
    func signOut() {
        UserSessionManager.shared.clearSession()
    }
    
    func loadUser() {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else {
            onError?("User not logged in")
            return
        }
        
        AuthManager.shared.getUserData(uid: uid) { data, error in
            
            if let error = error {
                self.onError?(error)
                return
            }
            
            guard let data,
                  let fullname = data["fullname"] as? String,
                  let email = data["email"] as? String else {
                self.onError?("Invalid data")
                return
            }

            let photoURL = data["photoURL"] as? String
            
            self.onDataLoaded?(fullname, email, photoURL)
        }
    }
}
