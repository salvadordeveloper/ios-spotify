//
//  ArtistCell.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import UIKit

class HomeItemCell: UICollectionViewCell {

    var track: ItemViewModel?
    static var id = "ArtistCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Title"
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        self.imageView.layer.cornerRadius = 0
        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
        self.titleLabel.textAlignment = .center
    }

    func setup(roundImage: Bool = false) {

        titleLabel.text = track?.artistName

        guard let url = track?.cover else {
            return
        }

        ImageManager.sharedInstance.getImageFromURL(url: url) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
                if roundImage {
                    self.roundImage()
                }
                self.layoutSubviews()
            case .failure:
                break
            }
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

    }

    private func roundImage() {
        self.imageView.layer.cornerRadius = imageView.bounds.size.height / 2
        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
        self.titleLabel.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
