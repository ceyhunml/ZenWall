//
//  LoginViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import Foundation
import UIKit

class LoginViewModel {
    
    private let manager = AuthManager.shared
    
    var successForSignIn: (() -> Void)?
    var successForReset: (() -> Void)?
    var failure: ((String) -> Void)?
    
    func signIn(email: String, password: String) {
        manager.signIn(email: email, password: password) { userId, error  in
            if let userId {
                UserDefaults.standard.set(userId, forKey: "userId")
                self.successForSignIn?()
            } else {
                self.failure?(error ?? "")
            }
        }
    }
    
    func resetPassword(email: String) {
        manager.resetPassword(email: email) { error in
            if let error {
                self.failure?(error)
            } else {
                self.successForReset?()
            }
        }
    }
}
