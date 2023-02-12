//
//  TopItemCell.swift
//  Spotify
//
//  Created by Salvador on 02/02/23.
//

import Foundation
import UIKit

class TopItemCell: UICollectionViewCell {

    static let id = "top"
    var track: ItemViewModel?

    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func prepareForReuse() {
        self.photoImageView.image = nil
        canLoadImage = false
    }

    var canLoadImage = true

    func setup() {
        titleLabel.text = track?.name

        guard let url = track?.cover else {
            return
        }

        canLoadImage = true

        ImageManager.sharedInstance.getImageFromURL(url: url) { result in
            switch result {
            case .success(let success):
                if self.canLoadImage {
                    self.photoImageView.image = success
                }
            case .failure:
               break
            }
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x444444, alpha: 0.8)
        clipsToBounds = true
        layer.cornerRadius = 3
        layer.masksToBounds = true

        addSubview(photoImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
