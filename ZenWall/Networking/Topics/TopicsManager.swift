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
    
    func getTopicPhotos(topicSlug: String, page: Int = 1, completion: @escaping ([UnsplashPhoto]?, String?) -> Void) {
        let url = UnsplashEndpoint.topicPhotos(slug: topicSlug, page: page).path
        
        manager.request(
            url: url,
            model: [UnsplashPhoto].self,
            completion: completion
        )
    }
}
