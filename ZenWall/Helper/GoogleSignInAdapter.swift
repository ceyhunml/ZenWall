//
//  GoogleSignInAdapter.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 13.12.25.
//

import Foundation
import GoogleSignIn

class GoogleSignInAdapter {
    
    static let shared = GoogleSignInAdapter()
    
    private init() {}
    
    func signIn(clientID: String, presentingVC: UIViewController, completion: @escaping (_ idToken: String?, _ accessToken: String?, _ fullname: String?, _ email: String?, _ error: String?) -> Void) {
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            
            if let error {
                completion(nil, nil, nil, nil, error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                completion(nil, nil, nil, nil, "No Google User")
                return
            }
            
            completion(
                user.idToken?.tokenString,
                user.accessToken.tokenString,
                user.profile?.name,
                user.profile?.email,
                nil
            )
        }
    }
}
