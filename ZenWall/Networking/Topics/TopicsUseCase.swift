//
//  TopicsUseCase.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

protocol TopicsUseCase {
    func getTopics(completion: @escaping ([UnsplashTopic]?, String?) -> Void)
}
