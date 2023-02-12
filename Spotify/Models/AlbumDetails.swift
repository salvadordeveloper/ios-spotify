//
//  AlbumDetailsModel.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct AlbumDetails: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case id
        case images
        case label
        case name
        case tracks
    }
}
