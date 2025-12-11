//
//  PasswordViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 02.12.25.
//

import Foundation

class PasswordViewModel {
    
    var coordinator: SignupCoordinator
    private let authManager = AuthManager.shared
    
    init(coordinator: SignupCoordinator) {
        self.coordinator = coordinator
    }
    
    func registerUser(with data: [String: String],
                      completion: @escaping (Bool, String?, String?, String?) -> Void) {
        
        let fullname = data["fullname"]!
        let email = data["email"]!
        let password = data["password"]!
        
        AuthManager.shared.signUp(email: email, password: password, fullname: fullname) { userId, error in
            if let error {
                completion(false, error, nil, nil)
            } else {
                UserDefaults.standard.set(fullname, forKey: "fullname")
                completion(true, nil, email, password)
            }
        }
    }
}
