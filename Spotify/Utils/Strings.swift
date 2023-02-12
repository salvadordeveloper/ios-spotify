//
//  Strings.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}
