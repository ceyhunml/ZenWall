//
//  AuthManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 26.11.25.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    private let backend: BackendService = FirebaseAdapter.shared
    
    func signIn(email: String, password: String,
                completion: @escaping (String?, String?) -> Void) {
        
        backend.signIn(email: email, password: password, completion: completion)
    }
    
    func signUp(email: String, password: String, fullname: String,
                completion: @escaping (String?, String?) -> Void) {
        backend.signUp(email: email, password: password, fullname: fullname, completion: completion)
    }
    
    func resetPassword(email: String,
                       completion: @escaping (String?) -> Void) {
        
        backend.resetPassword(email: email, completion: completion)
    }
    
    func checkEmailExists(email: String,
                          completion: @escaping (Bool, String?) -> Void) {
        
        backend.checkEmailExists(email: email, completion: completion)
    }
    
    func getUserData(uid: String,
                     completion: @escaping ([String: Any]?, String?) -> Void) {
        backend.fetchUserData(uid: uid, completion: completion)
    }
    
    func uploadProfileImage(uid: String,
                            imageData: Data,
                            completion: @escaping (String?, String?) -> Void) {
        backend.uploadProfileImage(uid: uid,
                                   imageData: imageData,
                                   completion: completion)
    }
    
    func updateUserPhotoURL(uid: String,
                            photoURL: String,
                            completion: @escaping (String?) -> Void) {
        backend.updateUserPhotoURL(uid: uid,
                                   photoURL: photoURL,
                                   completion: completion)
    }
}
