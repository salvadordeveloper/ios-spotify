//
//  SearchResultModel.swift
//  Spotify
//
//  Created by Salvador on 2023/3/22.
//

import Foundation

struct SearchResultModel: Codable {
    let albums: SearchAlbumModel
    let artists: SearchArtistsModel
    let playlists: SearchPlaylistsModel
    let tracks: SearchTracksModel
}

struct SearchAlbumModel: Codable {
    let items: [Album]
}
struct SearchArtistsModel: Codable {
    let items: [Artist]
}
struct SearchPlaylistsModel: Codable {
    let items: [Playlist]
}
struct SearchTracksModel: Codable {
    let items: [AudioTrack]
}
