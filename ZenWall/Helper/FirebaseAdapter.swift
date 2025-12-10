//
//  FirebaseAdapter.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 03.12.25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn

final class FirebaseAdapter: BackendService {
    
    static let shared = FirebaseAdapter()
    
    var auth = FirebaseAuth.Auth.auth()
    
    private init() {}
    
    // MARK: - Configure
    func configure() {
        FirebaseApp.configure()
    }
    
    // MARK: - Email Login
    func signIn(email: String, password: String,
                completion: @escaping (String?, String?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                completion(result?.user.uid, nil)
            }
        }
    }
    
    // MARK: - Email Register
    func signUp(email: String, password: String,
                completion: @escaping ((String?) -> Void)) {
        
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String,
                       completion: @escaping (String?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error?.localizedDescription)
        }
    }
    
    // MARK: - Google Login
    func signInWithGoogle(presentingVC: UIViewController,
                          completion: @escaping (String?, String?) -> Void) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(nil, "Missing Google Client ID")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let idToken = result?.user.idToken else {
                completion(nil, "No ID token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: result?.user.accessToken.tokenString ?? ""
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(nil, error.localizedDescription)
                } else {
                    completion(authResult?.user.uid, nil)
                }
            }
        }
    }
    
    //MARK: - Check Email
    func checkEmailExists(email: String, completion: @escaping (Bool, String?) -> Void) {
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
