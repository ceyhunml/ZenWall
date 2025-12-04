//
//  OfflineAlertManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 04.12.25.
//

import UIKit

final class InternetAlertManager {
    
    static let shared = InternetAlertManager()
    private init() {}
    
    private weak var alert: UIAlertController?
    
    func show() {
        guard alert == nil else { return }
        
        let alertVC = UIAlertController(
            title: "No Internet",
            message: "Please check your connection.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            
            InternetMonitor.shared.checkInternet { online in
                DispatchQueue.main.async {
                    
                    if online {
                        self.dismiss()
                        
                        if UserSessionManager.shared.isLoggedIn {
                            SceneDelegate.shared?.showTabBar()
                        } else {
                            SceneDelegate.shared?.showLogin()
                        }
                        
                    } else {
                        self.alert = nil
                        self.show()
                    }
                }
            }
        }))
        
        DispatchQueue.main.async {
            SceneDelegate.shared?.window?.rootViewController?.present(alertVC, animated: true)
        }
        
        self.alert = alertVC
    }
    
    func dismiss() {
        alert?.dismiss(animated: true)
        alert = nil
    }
}
