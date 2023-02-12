//
//  ImageManager.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import UIKit

class ImageManager {

    private let fileManager = LocalFileManager.instance
    private let folderName = "images"

    static let sharedInstance = ImageManager()

    func getImageFromURL(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let savedImage = fileManager.getImage(imageName: url.absoluteString, folderName: folderName) {
            completion(.success(savedImage))
        } else {

            NetworkManager.shared.downloadImage(from: url) { result in
                switch result {
                case .success(let image):
                    self.fileManager.saveImage(image: image,
                                               imageName: url.lastPathComponent,
                                               folderName: self.folderName)
                    completion(.success(image))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
}
