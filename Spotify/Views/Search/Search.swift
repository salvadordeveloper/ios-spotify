//
//  Search.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import UIKit

class SearchView: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let searchController: UISearchController = {
        let results = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: results)
        searchController.searchBar.placeholder = "Songs, Artist, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2, leading: 7, bottom: 2, trailing: 7)
            // group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitem: item, count: 2 )
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            // section
            return NSCollectionLayoutSection(group: group)
        }))

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self

        Task {
            do {
                let results = try await SpotifyRepository.shared.search(with: query)
                resultsController.update(with: results)
            } catch {

            }
        }
    }

    private var categories = [Category]()

    override func viewDidLoad() {

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        view.addSubview(collectionView)

        collectionView.register(CategoriesCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        Task {
            do {
                self.categories = try await SpotifyRepository.shared.getCategories()
                self.collectionView.reloadData()
            } catch {

            }
        }
    }
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoriesCollectionViewCell.identifier,
            for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]

        cell.configure(with: CategoriesCellViewModel(title: category.name, imageUrl: URL(string: category.icons.first?.url ?? "")))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoryView = CategoryView(category: categories[indexPath.row])
        categoryView.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(categoryView, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension SearchView: SearchResultViewControllerDelegate {

    func didTapResult(_ result: SearchResults) {
        switch result {
        case .artist(let model):
            let artistView = ArtistView(artist: model)
            navigationController?.pushViewController(artistView, animated: true)
        case .album(let model):
            let albumView = AlbumView(album: model)
            navigationController?.pushViewController(albumView, animated: true )
        case .track(let model):
            AudioManager.sharedInstance.playTrack(track: model)
        case .playlist(let model):
            let playListView = PlayListView(playlist: model)
            playListView.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(playListView, animated: true)
        }
    }
}
