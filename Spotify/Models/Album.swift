//
//  NewReleasesModel.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct NewReleases: Codable {
    let albums: AlbumsResponse
}
struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let albumType: String
    let availableMarkets: [String]?
    let id: String
    var images: [APIImage]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [Artist]

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case availableMarkets = "availableMarkets"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case artists
    }
}

struct SaveAlbumResponse: Codable {
    let items: [AlbumItems]
}

struct AlbumItems: Codable {
    let album: Album
}
