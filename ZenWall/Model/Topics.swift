//
//  Topics.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

// MARK: - Topic
struct UnsplashTopic: Codable, Identifiable, Hashable {
    let id, slug, title, description: String?
    let publishedAt, updatedAt, startsAt: String?
    let visibility: String?
    let featured: Bool?
    let totalPhotos: Int?
    let links: TopicLinks?
    let coverPhoto: UnsplashPhoto?
    let previewPhotos: [PreviewPhoto]?

    enum CodingKeys: String, CodingKey {
        case id, slug, title, description
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case startsAt = "starts_at"
        case visibility, featured
        case totalPhotos = "total_photos"
        case links
        case coverPhoto = "cover_photo"
        case previewPhotos = "preview_photos"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: UnsplashTopic, rhs: UnsplashTopic) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - TopicLinks (sadəcə Codable)
struct TopicLinks: Codable {
    let html, photos: String?
}

// MARK: - PreviewPhoto (sadəcə Codable)
struct PreviewPhoto: Codable {
    let id, slug: String?
    let createdAt, updatedAt: String?
    let blurHash: String?
    let urls: Urls?

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blurHash = "blur_hash"
        case urls
    }
}
