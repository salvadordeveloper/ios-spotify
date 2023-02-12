//
//  Playlist.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct Playlist: Codable {
    let description: String?
    let externalUrls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let name: String
    let owner: User?

    enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case owner
    }
}

struct PlaylistDetails: Codable {
    let description: String
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let tracks: PlaylistTracks

    enum CodingKeys: String, CodingKey {
        case description
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case owner
        case tracks
    }
}

struct FeaturedPlaylistModel: Codable {
    let message: String?
    let playlists: PlayListResponse
}

struct PlayListResponse: Codable {
    let href: String
    let items: [Playlist]
}

struct PlaylistTracks: Codable {
    let items: [PlaylistItems]
}

struct PlaylistItems: Codable {
    let track: AudioTrack
}

