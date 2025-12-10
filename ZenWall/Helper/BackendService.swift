//
//  BackendService.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 03.12.25.
//

import UIKit

protocol BackendService {
    func signIn(email: String, password: String,
                completion: @escaping (String?, String?) -> Void)
    
    func signUp(email: String, password: String, fullname: String,
                completion: @escaping (String?, String?) -> Void)
    
    func resetPassword(email: String,
                       completion: @escaping (String?) -> Void)
    
    func signInWithGoogle(presentingVC: UIViewController,
                          completion: @escaping (String?, String?) -> Void)
    
    func checkEmailExists(email: String,
                          completion: @escaping (Bool, String?) -> Void)
    func fetchUserData(uid: String,
                     completion: @escaping ([String: Any]?, String?) -> Void)
}
