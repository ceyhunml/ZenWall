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
        
        guard let email = data["email"],
              let password = data["password"] else {
            completion(false, "Missing fields", nil, nil)
            return
        }
        
        authManager.signUp(email: email, password: password) { error in
            if let error {
                completion(false, error, nil, nil)
            } else {
                completion(true, nil, email, password)
            }
        }
    }
}
