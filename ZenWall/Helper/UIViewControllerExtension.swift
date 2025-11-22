//
//  UIViewControllerExtension.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 15.11.25.
//

import Foundation
import UIKit

extension UIViewController {
    
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
        
        navigationItem.largeTitleDisplayMode = .never
        nav.navigationBar.prefersLargeTitles = false
        nav.navigationBar.tintColor = .white
    }
    
    func disableLargeTitle() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func alertFor(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
}
