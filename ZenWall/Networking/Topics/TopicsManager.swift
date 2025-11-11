//
//  TopicsManager.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

final class TopicsManager: TopicsUseCase {
    
    private let manager = NetworkManager.shared
    
    func getTopics(completion: @escaping ([UnsplashTopic]?, String?) -> Void) {
        manager.request(
            url: UnsplashEndpoint.topics.path,
            model: [UnsplashTopic].self,
            completion: completion
        )
    }
}
