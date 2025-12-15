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
    
    func signIn(clientID: String, presentingVC: UIViewController, completion: @escaping ((String?, String?) -> Void)) {
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            
            if let error { completion(nil, error.localizedDescription); return }
            
            guard let googleUser = result?.user else {
                completion(nil, "No Google User")
                return
            }
        }
    }
}
