//
//  PlayerView.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import UIKit

class PlayerView: UIViewController {

    var spotifyDelegate: SpotifyDelegate?
    let horizontalPadding = 20.0
    var currentTrack: AudioTrack? = nil
    var isSavedTrack = false
    var isShuffleActive = false
    var isRepeatActive = false

    private lazy var topBarStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hideButton, titlePlayerLabel, moreOptionsButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var hideButton: UIImageView = {
        let image = UIImage(named: "hide.png")
        let imageView = UIImageView(image: image!)
        return imageView
    }()

    private lazy var moreOptionsButton: UIImageView = {
        let image = UIImage(named: "more_options.png")
        let imageView = UIImageView(image: image!)
        return imageView
    }()

    private lazy var titlePlayerLabel: UILabel = {
        let text = UILabel(frame: .zero)
        text.text = ""
        text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        text.textColor = .white
        text.textAlignment = .center
        text.numberOfLines = 0
        return text
    }()

    private lazy var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var artists: [Artist]?

    private lazy var songTitleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songLabel, artistLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.text = "Silence"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()

    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Marshmello, Khalid"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(showArtist))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapAction)
        return label
    }()

    private lazy var songInfoStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songTitleStack, likeButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var likeButton: UIImageView = {
        let image = UIImage(named: "like.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTrackTap))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0.5, animated: true)
        progressView.trackTintColor = .gray
        progressView.tintColor = .white
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private lazy var musicControlStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [shuffleButton, previousButton, playButton, nextButton, repeatButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var shuffleButton: UIImageView = {
        let image = UIImage(named: "shuffle.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(shuffleTap))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var previousButton: UIImageView = {
        let image = UIImage(named: "previous.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlayerView.previousTrack))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var playButton: UIImageView = {
        let image = UIImage(named: "pause_rounded.png")
        let imageView = UIImageView(image: image!)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlayerView.playClick))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nextButton: UIImageView = {
        let image = UIImage(named: "next.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlayerView.nextTrack))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var repeatButton: UIImageView = {
        let image = UIImage(named: "repeat.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(repeatTap))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var deviceButton: UIImageView = {
        let image = UIImage(named: "device.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var shareButton: UIImageView = {
        let image = UIImage(named: "share.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var queueButton: UIImageView = {
        let image = UIImage(named: "queue.png")
        let imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var bottomStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deviceButton, shareStack])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var shareStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, queueButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var gradientBackground: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(hex: 0x737373).cgColor, UIColor(hex: 0x121212).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = view.bounds
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.insertSublayer(gradientBackground, at: 0)

        setupView()
        setupConstraints()
    }

    @objc func playTrackNotification(_ notification: NSNotification) {
        guard let track = notification.object as? AudioTrack else { return }
        playTrack(track: track)
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(playTrackNotification),
                                               name: Notification.Name("song"), object: nil)

        if let track = AudioManager.sharedInstance.currentTrack {
            playTrack(track: track)
        }

    }

    func setupView() {
        view.addSubview(topBarStack)
        view.addSubview(coverImage)
        view.addSubview(songInfoStack)
        view.addSubview(progressBar)
        view.addSubview(musicControlStack)
        view.addSubview(bottomStack)
        view.addSubview(coverView)

        setupPlayerStatus()
    }

    func setupPlayerStatus(){
        isShuffleActive = AudioManager.sharedInstance.shuffleActive
        shuffleButton.image = UIImage(named: isShuffleActive ? "shuffle_green" : "shuffle")

        isRepeatActive = AudioManager.sharedInstance.repeatActive
        repeatButton.image = UIImage(named: isRepeatActive ? "repeat_green" : "repeat")
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBarStack.topAnchor.constraint(equalTo: view.topAnchor),
            topBarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            topBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            topBarStack.heightAnchor.constraint(equalToConstant: 60),

            coverImage.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            coverImage.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            coverImage.widthAnchor.constraint(equalTo: coverView.widthAnchor),

            coverView.topAnchor.constraint(equalTo: topBarStack.bottomAnchor, constant: 10),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            coverView.bottomAnchor.constraint(equalTo: songInfoStack.topAnchor, constant: -20),

            songInfoStack.heightAnchor.constraint(equalToConstant: 50),
            songInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            songInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            songInfoStack.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -10),

            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            progressBar.bottomAnchor.constraint(equalTo: musicControlStack.topAnchor, constant: -10),

            musicControlStack.heightAnchor.constraint(equalToConstant: 100),
            musicControlStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            musicControlStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            musicControlStack.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: -10),

            bottomStack.heightAnchor.constraint(equalToConstant: 50),
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

    @objc func playClick() {
        if AudioManager.sharedInstance.isPlaying() {
            AudioManager.sharedInstance.pause()
            playButton.image = UIImage(named: "play_rounded.png")
        } else {
            AudioManager.sharedInstance.resume()
            playButton.image = UIImage(named: "pause_rounded.png")
        }
    }

    @objc func nextTrack() {
        AudioManager.sharedInstance.nextTrack()
    }

    @objc func previousTrack() {
        AudioManager.sharedInstance.previousTrack()
    }

    @objc func showArtist() {
        guard let artist = self.artists?.first else { return }
        dismiss(animated: true)
        spotifyDelegate?.showArtist(artistId: artist.id)
    }

    @objc func likeTrackTap() {

        if let track = currentTrack {
            Task {
                do {
                    if isSavedTrack {
                        _ = try await SpotifyRepository.shared.deleteTrack(trackId: track.id)
                    } else  {
                        _ = try await SpotifyRepository.shared.saveTrack(trackId: track.id)
                    }
                    isSavedTrack = !isSavedTrack
                    likeButton.image = UIImage(named: isSavedTrack ? "like" : "like_unfill")
                } catch {

                }
            }
        }
    }

    @objc func shuffleTap() {
        isShuffleActive = !isShuffleActive
        shuffleButton.image = UIImage(named: isShuffleActive ? "shuffle_green" : "shuffle")
        AudioManager.sharedInstance.shuffleActive = isShuffleActive
    }

    @objc func repeatTap(){
        isRepeatActive = !isRepeatActive
        repeatButton.image = UIImage(named: isRepeatActive ? "repeat_green" : "repeat")
        AudioManager.sharedInstance.repeatActive = isRepeatActive
    }
}

extension PlayerView {
    func playTrack(track: AudioTrack) {
        self.currentTrack = track
        self.artists = track.artists

        songLabel.text = track.name
        artistLabel.text = track.artists.first?.name

        if let url = track.album?.images.first?.url {
            ImageManager.sharedInstance.getImageFromURL(url: URL(string: url)!) { result in
                switch result {
                case .success(let image):
                    self.coverImage.image = image
                    if let color = self.coverImage.image?.averageColor, let color2 = color.darker(by: 20) {
                        self.gradientBackground.colors = [color.cgColor, color2.cgColor]
                    }
                case .failure:
                    break
                }
            }
        }

        AudioManager.sharedInstance.player?.addProgressObserver { progress in
            self.progressBar.setProgress(Float(progress), animated: false)
        }

        Task {
            do {
                self.isSavedTrack = try await SpotifyRepository.shared.isSavedTrack(trackId: track.id)
                likeButton.image = UIImage(named: isSavedTrack ? "like" : "like_unfill")
            } catch {

            }

        }
    }
}
