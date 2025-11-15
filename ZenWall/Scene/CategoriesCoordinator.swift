//
//  CategoriesCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 14.11.25.
//

import Foundation
import UIKit

final class CategoriesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = CategoriesViewModel(coordinator: self)
        let vc = CategoriesViewController(viewModel: vm, coordinator: self)

        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showList(for topicSlug: String) {
        let listVM = ListViewModel(onPhotoSelected: { [weak self] photo in
            self?.showWallpaperDetail(for: photo)
        })
        
        listVM.selectedTopic = topicSlug
        
        let listVC = ListViewController(viewModel: listVM, coordinator: self)
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func showWallpaperDetail(for photo: UnsplashPhoto) {
        let detailVM = WallpaperDetailsViewModel(photo: photo)
        let detailVC = WallpaperDetailsViewController(viewModel: detailVM)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
