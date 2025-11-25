//
//  WallpaperDetailsCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 22.11.25.
//

import Foundation
import UIKit

class WallpaperDetailsCoordinator: Coordinator {
    
    var photo: UnsplashPhoto
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, photo: UnsplashPhoto) {
        self.navigationController = navigationController
        self.photo = photo
    }
    
    func start() {
        let detailVM = WallpaperDetailsViewModel(photo: photo)
        let detailVC = WallpaperDetailsViewController(viewModel: detailVM)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.show(detailVC, sender: true)
    }
}
