//
//  UIViewControllerExtension.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 15.11.25.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Fully Transparent Nav Bar (No Shadow, No Background, No Large Title)
    func applyTransparentNavBar() {
        guard let nav = navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = .clear
        
        // Title settings
        navigationItem.largeTitleDisplayMode = .never
        nav.navigationBar.prefersLargeTitles = false
        nav.navigationBar.tintColor = .white     // back button color
    }
    
    
    // MARK: - Opaque Nav Bar (Colored)
    func applyColoredNavBar(background: UIColor = UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1)) {
        guard let nav = navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        
        nav.navigationBar.tintColor = .white
        nav.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Hide Large Title (For Screen Without Title)
    func disableLargeTitle() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - Enable Large Title
    func enableLargeTitle() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Remove Nav Bar Shadow Only
    func removeNavBarShadow() {
        guard let nav = navigationController else { return }
        let appearance = nav.navigationBar.standardAppearance
        appearance.shadowColor = .clear
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
    }
}
