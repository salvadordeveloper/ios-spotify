//
//  PlayListViewController.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class PlayListView: UIViewController {

    private let playlist: Playlist
    private var isSavedSongsPlayList = false

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
                                                UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in

            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 1,
                leading: 2, bottom: 1, trailing: 2)
            // Vertical group in horisontal group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)),
                subitem: item,
                count: 1)

            // Section
            let section = NSCollectionLayoutSection(group: group)

            if !self.isSavedSongsPlayList {
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.4)),
                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                ]
            }

            return section
        }))

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)
        collectionView.register(
            DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView

    }()

    private var viewModels = [TrackCellViewModel]()
    private var tracks = [AudioTrack]()

    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name

        if playlist.name == "Saved songs" {
            fetchSavedSongs()
            isSavedSongsPlayList = true
        } else {
            fetchData()
        }

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func fetchSavedSongs() {

        Task {
            do {
                self.tracks = try await SpotifyRepository.shared.getUserTracks().compactMap({$0.track})
                self.viewModels = tracks.compactMap({
                    TrackCellViewModel(id: $0.id, name: $0.name, artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
                })
                self.collectionView.reloadData()

            } catch {

            }
        }
    }

    private func fetchData() {
        Task {
            do {
                let model = try await SpotifyRepository.shared.getPlaylistDetails(for: playlist)
                self.tracks = model.tracks.items.compactMap({ $0.track })
                self.viewModels = model.tracks.items.compactMap({
                    TrackCellViewModel(id: $0.track.id, name: $0.track.name, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                })
                self.collectionView.reloadData()
            } catch {

            }
        }
    }
}

extension PlayListView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DetailHeaderView.identifier,
            for: indexPath) as? DetailHeaderView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(
            name: playlist.name, ownerName: playlist.owner?.displayName ?? "",
            description: playlist.description ?? "", artWorkUrl: URL(string: playlist.images?.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]

        AudioManager.sharedInstance.setPlaylist(list: tracks)
        AudioManager.sharedInstance.playTrack(track: track)
    }

}

extension PlayListView: PlaylistHeaderDelegate {

    func playAll(_ header: DetailHeaderView) {
        AudioManager.sharedInstance.setPlaylist(list: tracks)
        if let track = tracks.first {
            AudioManager.sharedInstance.playTrack(track: track)
        }
    }
    
}
