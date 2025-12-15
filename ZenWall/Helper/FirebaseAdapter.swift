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
    private let firestore = Firestore.firestore()
    private let usersCollection = Firestore.firestore().collection("users")
    
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
                fullname: String,
                completion: @escaping (String?, String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(nil, "User ID not found")
                return
            }
            UserSessionManager.shared.userId = userId
            
            self.saveUserData(userId: userId,
                              fullname: fullname,
                              email: email) { saveError in
                if let saveError {
                    completion(nil, saveError)
                } else {
                    completion(userId, nil)
                }
            }
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
            
            if let error { completion(nil, error.localizedDescription); return }
            
            guard let googleUser = result?.user else {
                completion(nil, "No Google User")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: googleUser.idToken?.tokenString ?? "",
                accessToken: googleUser.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error { completion(nil, error.localizedDescription); return }
                
                guard let userId = authResult?.user.uid else {
                    completion(nil, "Missing Firebase User ID")
                    return
                }
                
                let fullname = googleUser.profile?.name
                let email = googleUser.profile?.email
                
                self.saveUserData(userId: userId,
                                  fullname: fullname,
                                  email: email) { saveError in
                    if let saveError { completion(nil, saveError) }
                    else { completion(userId, nil) }
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
    
    //MARK: - Save User
    func saveUserData(userId: String, fullname: String?, email: String?, completion: @escaping (String?) -> Void) {
        
        let data: [String: Any] = [
            "fullname": fullname ?? "",
            "email": email ?? "",
            "favorites": [],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        UserSessionManager.shared.isLoggedIn = true
        
        usersCollection.document(userId).setData(data, merge: true) { error in
            if let error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchUserData(uid: String,
                       completion: @escaping ([String: Any]?, String?) -> Void) {
        
        usersCollection.document(uid).getDocument { snapshot, error in
            
            if let error {
                completion(nil, error.localizedDescription)
                return
            }
            
            completion(snapshot?.data(), nil)
        }
    }
    
    func uploadProfileImage(uid: String,
                            imageData: Data,
                            completion: @escaping (String?, String?) -> Void) {
        
        let storageRef = Storage.storage().reference()
            .child("profile_images/\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(nil, error.localizedDescription)
                    return
                }
                
                completion(url?.absoluteString, nil)
            }
        }
    }
    
    
    func updateUserPhotoURL(uid: String,
                            photoURL: String,
                            completion: @escaping (String?) -> Void) {
        
        usersCollection.document(uid)
            .updateData(["photoURL": photoURL]) { error in
                completion(error?.localizedDescription)
            }
    }
    
    func addFavorite(
        userId: String,
        favoriteId: String,
        completion: @escaping (String?) -> Void
    ) {
        usersCollection
            .document(userId)
            .updateData([
                "favorites": FieldValue.arrayUnion([favoriteId])
            ]) { error in
                completion(error?.localizedDescription)
            }
    }
    
    func removeFavorite(
        userId: String,
        favoriteId: String,
        completion: @escaping (String?) -> Void
    ) {
        usersCollection
            .document(userId)
            .updateData([
                "favorites": FieldValue.arrayRemove([favoriteId])
            ]) { error in
                completion(error?.localizedDescription)
            }
    }
    
    func fetchFavoriteIDs(
        userId: String,
        completion: @escaping ([String], String?) -> Void
    ) {
        usersCollection
            .document(userId)
            .getDocument { snapshot, error in
                
                if let error {
                    completion([], error.localizedDescription)
                    return
                }
                
                let favorites = snapshot?
                    .data()?["favorites"] as? [String] ?? []
                
                completion(favorites, nil)
            }
    }
}
