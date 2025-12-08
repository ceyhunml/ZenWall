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
    
    func build() -> [String: String]? {
        guard let fullname, let email, let password else { return nil }
        
        return [
            "fullname": fullname,
            "email": email,
            "password": password
        ]
    }
}
