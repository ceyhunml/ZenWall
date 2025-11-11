//
//  UnsplashPhoto.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

// MARK: - UnsplashPhoto
struct UnsplashPhoto: Codable {
    let id, slug: String?
    let createdAt, updatedAt, promotedAt: String?
    let width, height: Int?
    let color, blurHash, description, altDescription: String?
    let urls: Urls?
    let links: PhotoLinks?
    let likes: Int?
    let likedByUser: Bool?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case urls, links, likes
        case likedByUser = "liked_by_user"
        case user
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small, thumb: String?
}

// MARK: - PhotoLinks
struct PhotoLinks: Codable {
    let html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - User
struct User: Codable {
    let id, username, name, firstName, lastName: String?
    let portfolioURL, bio, location: String?
    let profileImage: ProfileImage?
    let social: Social?
    let totalPhotos, totalLikes: Int?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case portfolioURL = "portfolio_url"
        case bio, location
        case profileImage = "profile_image"
        case social
        case totalPhotos = "total_photos"
        case totalLikes = "total_likes"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String?
}

// MARK: - Social
struct Social: Codable {
    let instagramUsername, twitterUsername, portfolioURL: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
    }
}
