//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class TitleHeaderView: UICollectionReusableView {

    static let identifier = "TitleHeaderView"

    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with title: String) {
        label.text = title
    }
}
