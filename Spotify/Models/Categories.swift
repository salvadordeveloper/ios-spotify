//
//  CategoriesModel.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
