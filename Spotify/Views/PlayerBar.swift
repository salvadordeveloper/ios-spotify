//
//  PlayerBar.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class PlayerBar: UIView {

    var delegate: PlayerBarDelegate?

    var customView: UIView = {
        let bar = UIView()
        bar.layer.cornerRadius = 10
        bar.backgroundColor = UIColor(hex: 0x42382F)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Track"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var artistLabel: UILabel = {
        var label = UILabel()
        label.text = "Song"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var imageSong: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "ninja"))
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var playButton: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "play"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0.0, animated: false)
        progressView.trackTintColor = .gray
        progressView.tintColor = .white
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playTrackNotification),
                                               name: Notification.Name("song"), object: nil)

        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.showPlayerView(_:)))
        addGestureRecognizer(gesture)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.playTap(_:)))
        playButton.addGestureRecognizer(tap)
        playButton.isUserInteractionEnabled = true

        addSubview(customView)
        addSubview(nameLabel)
        addSubview(artistLabel)
        addSubview(progressBar)
        addSubview(imageSong)
        addSubview(playButton)

        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: self.topAnchor),
            customView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: 16),
            playButton.heightAnchor.constraint(equalToConstant: 16),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            imageSong.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),

            imageSong.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            imageSong.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -5),

            imageSong.widthAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: imageSong.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imageSong.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20),

            artistLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            progressBar.heightAnchor.constraint(equalToConstant: 1),
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])

        isHidden = true
    }

    func setPlayIcon() {
        self.playButton.image = UIImage(named: "play")
    }

    func setPauseIcon() {
        self.playButton.image = UIImage(named: "pause")
    }

    @objc func playTap(_ sender: UITapGestureRecognizer) {
        delegate?.playTap()
    }

    @objc func showPlayerView(_ sender: UITapGestureRecognizer) {
        delegate?.tap()
    }

    @objc func playTrackNotification(_ notification: NSNotification) {
        guard let track = notification.object as? AudioTrack else { return }
        playTrack(track: track)
    }

    func hidePlayerBar() {
        isHidden = true
    }

    func showPlayerBar() {
        isHidden = false
    }

    func playTrack(track: AudioTrack) {
        showPlayerBar()
        nameLabel.text = track.name
        artistLabel.text = track.artists.first?.name

        if let url = track.album?.images.first?.url {
            ImageManager.sharedInstance.getImageFromURL(url: URL(string: url)!) { result in
                switch result {
                case .success(let image):
                    self.imageSong.image = image
                    if let color = image.averageColor?.darker(by: 30) {
                        self.customView.backgroundColor = color
                    }
                case .failure:
                    break
                }
            }
        }

        

        

        

        AudioManager.sharedInstance.player?.addProgressObserver { progress in
            self.progressBar.setProgress(Float(progress), animated: false)
        }

        self.playButton.image = UIImage(named: "pause")
    }
}

protocol PlayerBarDelegate: AnyObject {
    func tap()
    func playTap()
}
