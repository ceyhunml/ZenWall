//
//  CategoriesViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation

final class CategoriesViewModel {
    
    weak var coordinator: CategoriesCoordinator?
    
    init(coordinator: CategoriesCoordinator?) {
        self.coordinator = coordinator
    }
    
    private(set) var categories = [UnsplashTopic]()
    private let manager = TopicsManager()
    
    var success: (() -> Void)?
    var failure: ((String) -> Void)?
    
    init() {
        fetchNewCategories()
    }
    
    func fetchNewCategories() {
        manager.getTopics { data, error in
            if let error {
                self.failure?(error)
            } else if let data {
                self.categories = data
                self.success?()
            }
        }
    }
}
