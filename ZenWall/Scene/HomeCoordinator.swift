//
//  HomeCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel { [weak self] photo in
            self?.showWallpaperDetail(for: photo)
        }
        
        let homeVC = HomeViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func showWallpaperDetail(for photo: UnsplashPhoto) {
        let detailVM = WallpaperDetailsViewModel(photo: photo)
        let detailVC = WallpaperDetailsViewController(viewModel: detailVM)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
