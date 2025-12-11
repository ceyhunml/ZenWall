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
    
    func setupDefaultBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1)
        appearance.shadowColor = .clear
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func alertFor(title: String,
                  message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func showDestructiveAlert(title: String,
                              message: String,
                              destructiveTitle: String = "Yes",
                              onConfirm: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: destructiveTitle,
                                      style: .destructive,
                                      handler: { _ in
            onConfirm()
        }))
        
        present(alert, animated: true)
    }
    
    func showActionSheet(title: String?,
                         message: String?,
                         actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)],
                         cancelTitle: String = "Cancel") {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions.forEach { item in
            sheet.addAction(UIAlertAction(title: item.title, style: item.style, handler: { _ in
                item.handler()
            }))
        }
        
        sheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        present(sheet, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
