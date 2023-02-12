//
//  NewHome.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

enum SectionType {
    case topItems(viewModel: [ItemViewModel])
    case newReleases(viewModel: [ItemViewModel])
    case topSongs(viewModel: [ItemViewModel])
    case topArtists(viewModel: [ItemViewModel])
    case userPlaylist(viewModel: [ItemViewModel])
    case featuredPlaylists(viewModel: [ItemViewModel])
    case recommended(viewModel: [ItemViewModel])

    var count: Int {
        switch self {
        case .topItems(let viewModel):
            return viewModel.count
        case .newReleases(let viewModel):
            return viewModel.count
        case .topSongs(let viewModel):
            return viewModel.count
        case .topArtists(let viewModel):
            return viewModel.count
        case .userPlaylist(let viewModel):
            return viewModel.count
        case .featuredPlaylists(let viewModel):
            return viewModel.count
        case .recommended(let viewModel):
            return viewModel.count
        }
    }

    var title: String {
        switch self {
        case .topItems:
            return "Recommended for you"
        case .newReleases:
            return "New Releases"
        case .topSongs:
            return "Your top songs"
        case .topArtists:
            return "Your top artists"
        case .userPlaylist:
            return "Your playlists"
        case .featuredPlaylists:
            return "Feautered playlists"
        case .recommended:
            return "Recommended"
        }
    }
}

class Home: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var sections: [SectionType] = []
    var newReleases: [Album] = []
    var topSongs: [AudioTrack] = []
    var topArtist: [Artist] = []
    var recommended: [AudioTrack] = []
    var userPlaylists: [Playlist] = []
    var featuredPlaylists: [Playlist] = []

    init() {
        super.init(collectionViewLayout:
                    UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return Home.createSectionLayout(section: sectionIndex)
        })
    }

    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {

        let supplymentryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60)),
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .topTrailing)
        ]

        switch section {
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))

            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(180)),
                subitem: item,
                count: 2)

            horizontalGroup.interItemSpacing = .fixed(10)

            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(180)),
                subitem: horizontalGroup,
                count: 3)

            verticalGroup.interItemSpacing = .fixed(10)

            // Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            section.orthogonalScrollingBehavior = .none
            section.boundarySupplementaryItems = supplymentryViews
            return section
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))

            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 10)

            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .absolute(180)),
                subitem: item,
                count: 1 )

            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            section.boundarySupplementaryItems = supplymentryViews
            return section
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData() async {

        do {
            topSongs = try await SpotifyRepository.shared.getUserTopTracks(limit: 6)
            topArtist = try await SpotifyRepository.shared.getUserTopArtists(limit: 8)
            newReleases = try await SpotifyRepository.shared.getNewReleases()
            userPlaylists = try await SpotifyRepository.shared.getUserPlaylists().items
            featuredPlaylists = try await SpotifyRepository.shared.getFeaturedPlaylist()
            var genres = try await SpotifyRepository.shared.getRecommendationGenre().genres
            genres.shuffle()
            let genresSet = Set(genres.prefix(5))

            recommended = try await SpotifyRepository.shared.getRecommendations(genres: genresSet).validTracks

        } catch {

        }

        self.sections.insert(.topItems(viewModel: self.topSongs.compactMap({
            return ItemViewModel(
                name: $0.name, artistName: $0.artists.first?.name ?? "-",
                cover: URL(string: $0.album?.images.first?.url ?? "")
            )
        })), at: 0)
        self.sections.append(.topArtists(viewModel: self.topArtist.compactMap({
            return ItemViewModel(
                name: $0.name,
                artistName: $0.name,
                cover: URL(string: $0.images?.first?.url ?? "")
            )
        })))
        self.sections.append(.newReleases(viewModel: self.newReleases.compactMap({
            return ItemViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "-",
                cover: URL(string: $0.images.first?.url ?? ""))
        })))
        self.sections.append(.userPlaylist(viewModel: self.userPlaylists.compactMap({
            return ItemViewModel(
                name: $0.name,
                artistName: $0.name,
                cover: URL(string: $0.images?.first?.url ?? ""))
        })))
        self.sections.append(.featuredPlaylists(viewModel: self.featuredPlaylists.compactMap({
            return ItemViewModel(
                name: $0.name,
                artistName: $0.description ?? "",
                cover: URL(string: $0.images?.first?.url ?? ""))
        })))
        self.sections.append(.recommended(viewModel: self.recommended.compactMap({
            return ItemViewModel(name: $0.name,
                                 artistName: $0.artists.first?.name ?? "-",
                                 cover: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        self.collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await loadData()
        }

        collectionView?.register(HomeItemCell.self, forCellWithReuseIdentifier: HomeItemCell.id)
        collectionView?.register(TitleHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: TitleHeaderView.identifier)

        collectionView?.register(TopItemCell.self, forCellWithReuseIdentifier: TopItemCell.id)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0 )
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCell.id,
                                                            for: indexPath) as? HomeItemCell else {
            return UICollectionViewCell()
        }

        let type = sections[indexPath.section]

        switch type {
        case .topItems(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopItemCell.id,
                                                                for: indexPath) as? TopItemCell else {
                return UICollectionViewCell()
            }
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case.newReleases(let items):
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case .topSongs(let items):
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case .userPlaylist(let items):
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case .featuredPlaylists(let items):
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case .recommended(let items):
            cell.track = items[indexPath.row]
            cell.setup()
            return cell
        case .topArtists(let items):
            cell.track = items[indexPath.row]
            cell.setup(roundImage: true)
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]

        switch section {
        case .topItems:
            let song = topSongs[indexPath.row]
            AudioManager.sharedInstance.playTrack(track: song)
        case .newReleases:
            let album = newReleases[indexPath.row]
            let albumView = AlbumView(album: album)
            self.navigationController?.pushViewController(albumView, animated: false)
        case .topSongs:
            let song = topSongs[indexPath.row]
            AudioManager.sharedInstance.playTrack(track: song)
        case .topArtists:
            let artist = topArtist[indexPath.row]
            let artistView = ArtistView(artist: artist)
            self.navigationController?.pushViewController(artistView, animated: true)
        case .userPlaylist:
            let playlist = userPlaylists[indexPath.row]
            let playlistView = PlayListView(playlist: playlist)
            self.navigationController?.pushViewController(playlistView, animated: false)
        case .featuredPlaylists:
            let playlist = featuredPlaylists[indexPath.row]
            let playListView = PlayListView(playlist: playlist)
            self.navigationController?.pushViewController(playListView, animated: false)
        case .recommended:
            let song = recommended[indexPath.row]
            AudioManager.sharedInstance.playTrack(track: song)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        return type.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderView.identifier,
            for: indexPath) as? TitleHeaderView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let title = sections[indexPath.section].title
        header.configure(with: title)
        return header
    }
}
