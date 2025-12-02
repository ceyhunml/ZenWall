//
//  AuthManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    func signIn(email: String, password: String, completion: @escaping (String?, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let user = result?.user {
                print(user.uid)
                completion(user.uid, nil)
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping((String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func checkEmailExists(_ email: String, completion: @escaping (Bool, String?) -> Void) {
        let tempPassword = "TEST1234"
        
        Auth.auth().createUser(withEmail: email, password: tempPassword) { result, error in
            
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                    
                case .emailAlreadyInUse:
                    completion(true, nil)
                    
                case .invalidEmail:
                    completion(false, "Invalid email format.")
                    
                default:
                    completion(false, error.localizedDescription)
                }
                
            } else {
                result?.user.delete { _ in }
                completion(false, nil)
            }
        }
    }
}
