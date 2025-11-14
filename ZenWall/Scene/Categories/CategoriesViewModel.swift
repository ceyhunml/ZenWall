//
//  CategoriesViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation

//struct CategoryModel {
//    let name: String
//    let imageURL: String
//}

final class CategoriesViewModel {
    
    private(set) var categories = [UnsplashTopic]()
    private let manager = TopicsManager()
    
    var success: (() -> Void)?
    var failure: ((String) -> Void)?
    
    init() {
        //fetchCategories()
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
    
    
//    func fetchCategories() {
//        categories = [
//            CategoryModel(
//                name: "Nature",
//                imageURL: "https://images.unsplash.com/photo-1501785888041-af3ef285b470"
//            ),
//            CategoryModel(
//                name: "Architecture",
//                imageURL: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29"
//            ),
//            CategoryModel(
//                name: "Minimal",
//                imageURL: "https://images.unsplash.com/photo-1504548840739-580b10ae7715?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1740"
//            ),
//            CategoryModel(
//                name: "Abstract",
//                imageURL: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1528"
//            ),
//            CategoryModel(
//                name: "City",
//                imageURL: "https://images.unsplash.com/photo-1508057198894-247b23fe5ade"
//            ),
//            CategoryModel(
//                name: "Animals",
//                imageURL: "https://images.unsplash.com/photo-1508672019048-805c876b67e2"
//            )
//        ]
//        onDataUpdate?()
//    }
}
