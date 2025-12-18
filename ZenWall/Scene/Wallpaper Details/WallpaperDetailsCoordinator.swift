//
//  WallpaperDetailsCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 22.11.25.
//

import Foundation
import UIKit

class WallpaperDetailsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let photo: UnsplashPhoto
    private let sourceImageView: UIImageView
    
    init(
        navigationController: UINavigationController,
        photo: UnsplashPhoto,
        sourceImageView: UIImageView
    ) {
        self.navigationController = navigationController
        self.photo = photo
        self.sourceImageView = sourceImageView
    }
    
    func start() {
        let detailVM = WallpaperDetailsViewModel(photo: photo)
        let detailVC = WallpaperDetailsViewController(viewModel: detailVM)
        
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.preferredTransition = .zoom { _ in
            return self.sourceImageView
        }
        navigationController.pushViewController(detailVC, animated: true)
    }
}
