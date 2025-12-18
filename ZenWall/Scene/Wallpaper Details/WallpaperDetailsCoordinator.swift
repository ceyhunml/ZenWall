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
    private let sourceCell: UICollectionViewCell
    
    init(
        navigationController: UINavigationController,
        photo: UnsplashPhoto,
        sourceCell: UICollectionViewCell
    ) {
        self.navigationController = navigationController
        self.photo = photo
        self.sourceCell = sourceCell
    }
    
    func start() {
        let detailVM = WallpaperDetailsViewModel(photo: photo)
        let detailVC = WallpaperDetailsViewController(viewModel: detailVM)
        
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.preferredTransition = .zoom(
            sourceViewProvider: {context in 
                self.sourceCell.contentView
            }
        )
        navigationController.pushViewController(detailVC, animated: true)
    }
}
