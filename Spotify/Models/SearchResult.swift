//
//  SearchResult.swift
//  Spotify
//
//  Created by Salvador on 12/02/23.
//

import Foundation

struct SearchResulsResponse: Codable {
    let albums: SearchAlbum
    let artists: SearchArtists
    let playlists: SearchPlaylists
    let tracks: SearchTracks
}

struct SearchAlbum: Codable {
    let items: [Album]
}

struct SearchArtists: Codable {
    let items: [Artist]
}

struct SearchPlaylists: Codable {
    let items: [Playlist]
}

struct SearchTracks: Codable {
    let items: [AudioTrack]
}

enum SearchResults{
    case album(model: Album)
    case artist(model: Artist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
