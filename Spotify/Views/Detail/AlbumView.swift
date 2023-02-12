//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class AlbumView: UIViewController {

    private let album: Album
    private var viewModels = [TrackCellViewModel]()
    private var tracks = [AudioTrack]()

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
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),
            subitem: item,
            count: 1)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.4)),
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))

    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.identifier)
        collectionView.register(DetailHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: DetailHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        configureNavBar()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    private func fetchData() {
        Task {
            do {
                self.tracks = (try await SpotifyRepository.shared.getAlbumDetails(album: self.album)).tracks.items
                self.viewModels = tracks.compactMap({
                    TrackCellViewModel(id: $0.id, name: $0.name, artistName: $0.artists.first?.name, artworkURL: nil)
                })
                self.collectionView.reloadData()
            } catch {

            }
        }
    }

    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self, action: #selector(didTapAction))
    }

    @objc func didTapAction() {
        let actionSheet = UIAlertController(title: album.name, message: "Actions", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}

extension AlbumView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier,
                                                            for: indexPath) as? TrackCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: DetailHeaderView.identifier,
            for: indexPath) as? DetailHeaderView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let headerViewModel = PlaylistHeaderViewModel(
            name: album.name,
            ownerName: album.artists.first?.name ?? "-",
            description: "Release Data:",
            artWorkUrl: URL(string: album.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album

        AudioManager.sharedInstance.playTrack(track: track)
    }

}

extension AlbumView: PlaylistHeaderDelegate {
    func playAll(_ header: DetailHeaderView) {
        AudioManager.sharedInstance.setPlaylist(list: tracks)
        if let track = tracks.first {
            AudioManager.sharedInstance.playTrack(track: track)
        }
    }
}
