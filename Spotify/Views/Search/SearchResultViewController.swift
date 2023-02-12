//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResults]
}

protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResults)
}
class SearchResultViewController: UIViewController {

    private var sections: [SearchSection] = []
    weak var delegate: SearchResultViewControllerDelegate?

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchResultsDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultsDefaultTableViewCell.identifier)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

    }

    public func update(with results: [SearchResults]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)

        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty

    }

}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsDefaultTableViewCell.identifier,
            for: indexPath) as? SearchResultsDefaultTableViewCell else {
            return UITableViewCell()
        }
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            cell.configure(
                with: SearchResultsCellViewModel(title: model.name,
                                                        imageUrl: URL(string: model.images?.first?.url ?? ""),
                                                        subTitle: nil))
        case .album(let model):
            cell.configure(
                with: SearchResultsCellViewModel(title: model.name,
                                                        imageUrl: URL(string: model.images.first?.url ?? ""),
                                                        subTitle: model.artists.first?.name ?? ""))
        case .track(let model):
            cell.configure(
                with: SearchResultsCellViewModel(title: model.name,
                                                        imageUrl: URL(string:model.album?.images.first?.url ?? ""),
                                                        subTitle: model.artists.first?.name ?? ""))
        case .playlist(let model):
            cell.configure(
                with: SearchResultsCellViewModel(title: model.name ?? "",
                                                        imageUrl: URL(string: model.images?.first?.url ?? ""),
                                                        subTitle: model.owner?.displayName))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
}
