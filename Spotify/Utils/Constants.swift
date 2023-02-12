//
//  Constants.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

class Constants {

    static let baseAPIURL =  "https://api.spotify.com/v1"

    static let clientID = "YOUR_CLIENT_ID"
    static let clientSecret = "YOUR_CLIENT_SECRET"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"

    static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-read%20user-library-modify%20user-read-email%20user-top-read%20user-read-recently-played"
    static let redirectURI = "https://www.iosacademy.io"

    static let profileUrl = baseAPIURL + "/me"
    static let userTracksUrl = baseAPIURL + "/me/tracks"
    static let userTracksContainsUrl = baseAPIURL + "/me/tracks/contains"

    static let userTopTracksUrl = baseAPIURL + "/me/top/tracks"
    static let userTopArtistUrl = baseAPIURL + "/me/top/artists"

    static let artistUrl = baseAPIURL + "/artists"

    static let browseNewReleaseUrl = baseAPIURL + "/browse/new-releases?country=us"
    static let featurePlaylistUrl = baseAPIURL + "/browse/featured-playlists?country=us&limit=50"
    static let recommendationsGenreUrl = baseAPIURL + "/recommendations/available-genre-seeds"
    static let recommendationsUrl = baseAPIURL + "/recommendations?country=IN&limit=40"
    static let albumDetailsUrl = baseAPIURL + "/albums/"
    static let myAlbumstUrl = baseAPIURL + "/me/albums"
    static let myPlaylistUrl = baseAPIURL + "/me/playlists"
    static let playlistDetailsUrl = baseAPIURL + "/playlists/"
    static let categoryUrl = baseAPIURL + "/browse/categories"
    static let searchUrl = baseAPIURL + "/search?type=album,artist,playlist,track&include_external=audio&limit=10"
}
