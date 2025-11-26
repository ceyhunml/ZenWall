//
//  LoginViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import Foundation

class LoginViewModel {
    
    let manager = AuthManager.shared
    
    func signIn(email: String, password: String) {
        manager.signIn(email: email, password: password) { userId in
            if let userId {
                UserDefaults.standard.set(userId, forKey: "userId")
//                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//                    sceneDelegate.window?.rootViewController = sceneDelegate.createTabBar()
                print("Login success!")
            } else {
                print("Login failed!")
            }
        }
    }
}
