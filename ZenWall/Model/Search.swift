//
//  Search.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

struct SearchResponse: Codable {
    let total, totalPages: Int?
    let results: [UnsplashPhoto]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
