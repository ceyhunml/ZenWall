//
//  EmailViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 27.11.25.
//

import Foundation

class EmailViewModel {
    
    var coordinator: SignupCoordinator
    
    init(coordinator: SignupCoordinator) {
        self.coordinator = coordinator
    }
    
    private let manager = AuthManager.shared
    
    var email: String?
    
    var onEmailCheck: ((Bool, String?) -> Void)?
    
    func checkEmail(_ email: String) {
        manager.checkEmailExists(email) { exists, error in
            self.onEmailCheck?(exists, error)
        }
    }
}
