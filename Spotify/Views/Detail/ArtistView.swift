//
//  ArtistViewController.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class ArtistView: UIViewController {

    let artist: Artist

    public var isOwner = false

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in

        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 2, bottom: 1, trailing: 2)
        // Vertical group in horisontal group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70)),
            subitem: item,
            count: 1)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.4)),
                    elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))

    init(artist: Artist) {
        self.artist = artist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    private var viewModels = [TrackCellViewModel]()
    private var tracks = [AudioTrack]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)
        collectionView.register(
            DetailHeaderView.self, forSupplementaryViewOfKind:
                UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.bottom = 100

        configureNavBar()
        fetchData()
    }

    private func configureNavBar() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer ) {
        guard gesture.state == .began else {
            return
        }

        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        let actionSheet = UIAlertController(
            title: trackToDelete.name,
            message: "Would you like to remove this from playlist",
            preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {[weak self] _ in
//
       // }))
        present(actionSheet, animated: true)
    }

    private func fetchData() {

        Task {
            do {
                self.tracks = try await SpotifyRepository.shared.getArtistTopTracks(artist: artist)
                self.viewModels = tracks.map({
                    TrackCellViewModel(
                        id: $0.id,
                        name: $0.name,
                        artistName: $0.artists.first?.name ?? "",
                        artworkURL: $0.album?.images.randomElement()?.url.toURL())
                })
                collectionView.reloadData()
            } catch {

            }
        }
    }

}

extension ArtistView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
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
            name: artist.name,
            ownerName: artist.name,
            description: artist.name,
            artWorkUrl: URL(string: artist.images?.first?.url ?? "")
        )

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

extension ArtistView: PlaylistHeaderDelegate {
    func playAll(_ header: DetailHeaderView) {
        AudioManager.sharedInstance.setPlaylist(list: tracks)
        if let track = tracks.first {
            AudioManager.sharedInstance.playTrack(track: track)
        }
    }
}
