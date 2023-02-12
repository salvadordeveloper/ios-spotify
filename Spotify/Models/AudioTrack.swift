//
//  AudioTrack.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let availableMarkets: [String]?
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: [String: String]
    let id: String
    let name: String
    let previewUrl: String?

    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalUrls = "external_urls"
        case id
        case name
        case previewUrl = "preview_url"
    }
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
