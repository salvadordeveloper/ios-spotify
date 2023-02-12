//
//  PlaylistsTableViewCell.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

struct PlaylistsTableViewCellViewModel {
    let imgUrl: URL?
    let name: String?
}

class PlaylistsTableViewCell: UITableViewCell {

    static let identifier = "PlaylistsTableViewCell"

    private lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.backgroundColor = .black.lighter(by: 15)
        imgV.layer.cornerRadius = 3
        imgV.layer.masksToBounds = true
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()

    private lazy var likeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "like")
        image.isHidden = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeImage)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),

            likeImage.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            likeImage.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            likeImage.widthAnchor.constraint(equalToConstant: 20),
            likeImage.heightAnchor.constraint(equalToConstant: 20)
        ])

        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        nameLabel.text = ""
    }

    func configure(with viewModel: PlaylistsTableViewCellViewModel) {

        nameLabel.text = viewModel.name

        if viewModel.name == "Saved songs" {
            likeImage.isHidden = false
        }

        if let url = viewModel.imgUrl {
            imgView.imageURLLoad(url: url)

        }
    }

}
