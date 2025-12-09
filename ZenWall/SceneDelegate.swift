//
//  SceneDelegate.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    static weak var shared: SceneDelegate?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        SceneDelegate.shared = self
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        InternetMonitor.shared.onStatusChange = { online in
            if online {
                InternetAlertManager.shared.dismiss()
            } else {
                InternetAlertManager.shared.show()
            }
        }

        if UserSessionManager.shared.isLoggedIn {
            showTabBar()
        } else {
            showLogin()
        }

        window?.makeKeyAndVisible()
    }
    
    func showLogin() {
        let vc = LoginViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    func showTabBar() {
        window?.rootViewController = CustomTabBar()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
