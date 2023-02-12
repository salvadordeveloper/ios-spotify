//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

protocol PlaylistHeaderDelegate: AnyObject {
    func playAll(_ header: DetailHeaderView)
}

final class DetailHeaderView: UICollectionReusableView {

    static let identifier = "ArtistHeaderView"

    weak var delegate: PlaylistHeaderDelegate?

    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        [self.nameLabel, self.descriptionLabel, self.ownerLabel].forEach { stackView.addArrangedSubview($0) }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))

        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(stackView)
        addSubview(playAllButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),


            playAllButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            playAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            playAllButton.widthAnchor.constraint(equalToConstant: 60),
            playAllButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func didTapPlayAll() {
        delegate?.playAll(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name

        if let url = viewModel.artWorkUrl {
            imageView.imageURLLoad(url: url)
        }
    }

}
