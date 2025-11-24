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
        navigationController.pushViewController(categoriesVC, animated: false)
    }
    
    func showList(for topicSlug: String, topicName: String) {
        let listVM = ListViewModel()
        listVM.selectedTopic = topicSlug
        listVM.selectedTopicForUI = topicName
        let listVC = ListViewController(viewModel: listVM)
        navigationController.show(listVC, sender: nil)
    }
}
