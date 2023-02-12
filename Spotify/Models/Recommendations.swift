//
//  RecommendationsModel.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct Recommendations: Codable {
    let tracks: [AudioTrack]

    var validTracks: [AudioTrack] {
        return self.tracks.filter { $0.previewUrl != nil}
    }
}

struct RecommendedGenre: Codable {
    let genres: [String]
}
