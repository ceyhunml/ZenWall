//
//  HomeCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 12.11.25.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        navigationController.show(homeVC, sender: nil)
    }
}
