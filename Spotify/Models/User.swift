//
//  UserProfile.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String
    let email: String
    let explicitContent: [String: Bool]
    let externalUrls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
    let type: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case id
        case product
        case images
        case type
    }
}

struct User: Codable {
    let displayName: String
    let id: String
    let externalUrls: [String: String]
    let type: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case id
        case externalUrls = "external_urls"
        case type
    }
}

