//
//  TrackCell.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class TrackCell: UICollectionViewCell {

    static let identifier = "TrackCell"
    var isSavedTrack = false
    var trackId: String? = nil

    private let trackCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var likeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like_unfill")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTrackTap))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(trackCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            trackCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trackCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            trackCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            trackCoverImageView.widthAnchor.constraint(equalTo: trackCoverImageView.heightAnchor),

            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trackNameLabel.leadingAnchor.constraint(equalTo: trackCoverImageView.trailingAnchor, constant: 15),
            trackNameLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10),

            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: trackCoverImageView.trailingAnchor, constant: 15),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverImageView.image = nil
    }

    func showImage() {
        trackCoverImageView.isHidden = false
    }

    func hideImage() {
        trackCoverImageView.isHidden = true
        trackCoverImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }

    func configure(with viewModel: TrackCellViewModel) {
        self.trackId = viewModel.id
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName

        if let url = viewModel.artworkURL {
            trackCoverImageView.imageURLLoad(url: url)
        } else {
            hideImage()
        }

        checkStatusTrack(trackId: viewModel.id)
     }

    func checkStatusTrack(trackId: String) {
        Task {
            do {
                self.isSavedTrack = try await SpotifyRepository.shared.isSavedTrack(trackId: trackId)
                likeButton.image = UIImage(named: isSavedTrack ? "like" : "like_unfill")
            } catch {

            }

        }
    }

    @objc func likeTrackTap() {

        if let trackId = trackId {
            Task {
                do {
                    if isSavedTrack {
                        _ = try await SpotifyRepository.shared.deleteTrack(trackId: trackId)
                    } else  {
                        _ = try await SpotifyRepository.shared.saveTrack(trackId: trackId)
                    }
                    isSavedTrack = !isSavedTrack
                    likeButton.image = UIImage(named: isSavedTrack ? "like" : "like_unfill")
                } catch {

                }
            }
        }
    }
}
