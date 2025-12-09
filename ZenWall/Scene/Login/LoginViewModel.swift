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
    
    var prefillEmail: String?
    var prefillPassword: String?
    
    func signIn(email: String, password: String, completion: @escaping (String?, String?) -> Void) {
        manager.signIn(email: email, password: password) { userId, error  in
            if let userId {
                UserDefaults.standard.set(userId, forKey: "userId")
                completion(userId, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func signInWithGoogle(from vc: UIViewController,
                          completion: @escaping (String?, String?) -> Void) {
        manager.signInWithGoogle(presentingVC: vc, completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping (String?) -> Void) {
        manager.resetPassword(email: email, completion: completion)
    }
}
