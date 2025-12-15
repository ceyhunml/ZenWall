//
//  CustomTabBar.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit

final class CustomTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
    }
    
    // MARK: - Appearance
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.10, green: 0.20, blue: 0.15, alpha: 1.0)
        
        let selectedColor = UIColor.white
        let unselectedColor = UIColor(red: 0.58, green: 0.74, blue: 0.65, alpha: 1.0)
        
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: unselectedColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = selectedColor
        tabBar.unselectedItemTintColor = unselectedColor
    }
    
    // MARK: - View Controllers
    private func setupViewControllers() {
        
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator.start()
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let categoriesNav = UINavigationController()
        let categoriesCoordinator = CategoriesCoordinator(navigationController: categoriesNav)
        categoriesCoordinator.start()
        categoriesNav.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "circle.grid.2x2"),
            selectedImage: UIImage(systemName: "circle.grid.2x2.fill")
        )
        
        let favoritesNav = UINavigationController()
        favoritesNav.navigationBar.prefersLargeTitles = true
        let favoritesVC = FavoritesViewController()
        favoritesVC.view.backgroundColor = .systemBackground
        favoritesNav.viewControllers = [favoritesVC]
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let profileNav = UINavigationController()
        let profileVC = ProfileViewController()
        profileVC.view.backgroundColor = .systemBackground
        profileNav.viewControllers = [profileVC]
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        setViewControllers(
            [homeNav, categoriesNav, favoritesNav, profileNav],
            animated: false
        )
    }
}
