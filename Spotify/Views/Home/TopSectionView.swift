//
//  TopSectionView.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import UIKit
import SwiftUI

class TopSectionView: UIStackView {

    var sections: [AudioTrack]?

    override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 15.0
        addArrangedSubview(TopItemRow())
        addArrangedSubview(TopItemRow())
        addArrangedSubview(TopItemRow())
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TopItemRow: UIStackView {

    var section: [AudioTrack]?

    override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 12.0

        addArrangedSubview(TopItemCell())
        addArrangedSubview(TopItemCell())
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
