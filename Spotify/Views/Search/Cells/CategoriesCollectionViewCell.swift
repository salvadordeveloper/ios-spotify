//
//  CategoriesCollectionViewCell.swift
//  SpotifyDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/3/21.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoriesCollectionViewCell"

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = nil
    }

    func configure(with viewModel: CategoriesCellViewModel) {
        label.text = viewModel.title

        if let url = viewModel.imageUrl {
            ImageManager().getImageFromURL(url: url) { result in
                switch result {
                case .success(let success):
                    self.imageView.image = success
                case .failure:
                    break
                }

            }

        }

    }
}
