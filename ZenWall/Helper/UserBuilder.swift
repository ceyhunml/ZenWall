//
//  UserBuilder.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 27.11.25.
//

import Foundation

class UserBuilder {
    
    private let manager = AuthManager.shared
    private var fullname: String?
    private var email: String?
    private var password: String?
    
    func setFullname(fullname: String) {
        self.fullname = fullname
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func build(completion: @escaping (Bool, String?, String?, String?) -> Void) {
        guard let fullname = fullname,
              let email = email,
              let password = password else {
            completion(false, "Missing fields", nil, nil)
            return
        }

        manager.signUp(email: email, password: password) { error in
            if let error {
                completion(false, error, nil, nil)
            } else {
                completion(true, nil, email, password)
            }
        }
    }
}
