//
//  SongModel.swift
//  Spotify
//
//  Created by Salvador Valverde on 09/08/22.
//

import Foundation

struct SongModel: Codable {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
