//
//  SpotifyRepository.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

class SpotifyRepository {
   static let shared = SpotifyRepository()

   public func getUserTracks() async throws -> [UserTrack] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.userTracksUrl)!) {( result: Result<UserTrackResponse, Error>) in
            switch result {
            case .success(let success):
               continuation.resume(returning: success.items)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }

         }
      }
   }

   public func getUserTopTracks(offset: Int = 0, limit: Int = 20) async throws -> [AudioTrack] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.userTopTracksUrl + "?offset=\(offset)&limit=\(limit)")!) { (result: Result<UserTopTrackResponse, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.items)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getArtist(artistId: String) async throws -> Artist {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.artistUrl + "/\(artistId)")!) { ( result: Result<Artist, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getUserTopArtists(offset: Int = 0, limit: Int = 20) async throws -> [Artist] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.userTopArtistUrl + "?offset=\(offset)&limit=\(limit)")!) { (result: Result<UserTopArtistResponse, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.items)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getArtistTopTracks(artist: Artist) async throws -> [AudioTrack] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.artistUrl + "/\(artist.id)/top-tracks?country=us" )!) { (result: Result<ArtistTopTracksResponse, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.tracks)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getNewReleases() async throws -> [Album] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.browseNewReleaseUrl)!) { (result: Result<NewReleases, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.albums.items)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }

   }

   public func getFeaturedPlaylist() async throws -> [Playlist] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.featurePlaylistUrl)!) { (result: Result<FeaturedPlaylistModel, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.playlists.items)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getRecommendationGenre() async throws -> RecommendedGenre {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.recommendationsGenreUrl)!) { (result: Result<RecommendedGenre, Error>) in
            switch result {
            case .success(let success):
               continuation.resume(returning: success)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func getRecommendations(genres: Set<String>) async throws -> Recommendations {
      let seeds = genres.joined(separator: ",")

      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.recommendationsUrl + "&seed_genres=\(seeds)")!) {
            (result: Result<Recommendations, Error>) in
            continuation.resume(with: result)
         }
      }

   }

   public func getCategories() async throws -> [Category] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.categoryUrl + "?country=us&limit=50")!) { (result: Result<CategoriesResponse, Error>)  in
            switch result {
            case .success(let categories):
               continuation.resume(returning: categories.categories.items)
            case .failure(let error):
               continuation.resume(throwing: error)
            }
         }
      }
   }

   public func getCategoryPlaylists(category: Category) async throws -> [Playlist] {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.categoryUrl + "/\(category.id)/playlists?limit=10")!) { (result: Result<FeaturedPlaylistModel, Error>) in
            switch result {
            case .success(let response):
               continuation.resume(returning: response.playlists.items)
            case .failure(let error):
               continuation.resume(throwing: error)
            }
         }
      }
   }

   public func getAlbumDetails(album: Album) async throws -> AlbumDetails {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.albumDetailsUrl + album.id)!){ (result: Result<AlbumDetails, Error>) in
            continuation.resume(with: result)
         }
      }
   }

   public func getUserPlaylists() async throws -> PlayListResponse {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.myPlaylistUrl)!) { (result: Result<PlayListResponse, Error>) in
            continuation.resume(with: result)
         }
      }
   }

   public func getPlaylistDetails(for playlist: Playlist) async throws -> PlaylistDetails {
      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: URL(string: Constants.playlistDetailsUrl + playlist.id!)!) {
            (result: Result<PlaylistDetails, Error>) in
            continuation.resume(with: result)
         }
      }
   }

   public func search(with query: String) async throws -> [SearchResults] {
      let url = URL(string: Constants.searchUrl + "&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!

      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: url) { (result: Result<SearchResulsResponse, Error>) in
            switch result {
            case .success(let results):
               var searchResult = [SearchResults]()
               searchResult.append(contentsOf: results.tracks.items.compactMap({ .track(model: $0)}))
               searchResult.append(contentsOf: results.albums.items.compactMap({ .album(model: $0)}))
               searchResult.append(contentsOf: results.artists.items.compactMap({ .artist(model: $0)}))
               searchResult.append(contentsOf: results.playlists.items.compactMap({ .playlist(model: $0)}))

               continuation.resume(returning: searchResult)
            case .failure(let error):
               continuation.resume(throwing: error)
            }
         }
      }
   }

   public func saveTrack(trackId: String) async throws -> Bool {

      let url = URL(string: Constants.userTracksUrl + "?ids=\(trackId)")!

      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: url, httpMethod: .put) { (result: Result<GeneralResponse, Error>) in
            switch result {
            case .success(let success):
               continuation.resume(returning: success.success)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func deleteTrack(trackId: String) async throws -> Bool {
      let url = URL(string: Constants.userTracksUrl + "?ids=\(trackId)")!

      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: url, httpMethod: .delete) { (result: Result<GeneralResponse, Error>) in
            switch result {
            case .success(let success):
               continuation.resume(returning: success.success)
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

   public func isSavedTrack(trackId: String) async throws -> Bool {
      let url = URL(string: Constants.userTracksContainsUrl + "?ids=\(trackId)")!

      return try await withCheckedThrowingContinuation { continuation in
         NetworkManager.shared.request(fromURL: url) { (result: Result<[Bool], Error>) in
            switch result {
            case .success(let success):
               if let status = success.first {
                  continuation.resume(returning: status)
               }
            case .failure(let failure):
               continuation.resume(throwing: failure)
            }
         }
      }
   }

}
