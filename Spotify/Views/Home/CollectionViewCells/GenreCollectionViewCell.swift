//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemBlue,
        .systemRed,
        .systemTeal,
        .systemYellow,
        .systemGreen,
        .systemOrange,
        .darkGray,
        .systemMint,
        .systemIndigo
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func configure(with title: String) {
        label.text = title
        contentView.backgroundColor = colors.randomElement()
    }
}
