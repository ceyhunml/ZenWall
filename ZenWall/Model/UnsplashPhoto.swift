//
//  UnsplashPhoto.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 10.11.25.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String?
    let createdAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let altDescription: String?
    let likes: Int?
    let urls: Urls?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case description
        case altDescription = "alt_description"
        case likes
        case urls
        case user
    }
}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

enum DownloadQuality {
    case full
    case regular
}

struct User: Codable {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
