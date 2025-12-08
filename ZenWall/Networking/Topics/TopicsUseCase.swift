//
//  TopicsUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

protocol TopicsUseCase {
    func getTopics(completion: @escaping ([UnsplashTopic]?, String?) -> Void)
    func getTopicPhotos(topicSlug: String, page: Int, completion: @escaping ([UnsplashPhoto]?, String?) -> Void)
}
