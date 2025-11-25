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
        let categoriesVC = CategoriesViewController(viewModel: CategoriesViewModel())
        navigationController.show(categoriesVC, sender: nil)
    }
    
    func showList(for topicSlug: String, topicName: String) {
        let listVC = ListViewController(viewModel: .init(selectedTopic: topicSlug, selectedTopicForUI: topicName))
        navigationController.show(listVC, sender: nil)
    }
}
