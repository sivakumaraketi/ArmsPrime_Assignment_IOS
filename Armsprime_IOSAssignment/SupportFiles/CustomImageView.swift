//
//  CustomImageView.swift
//  Armsprime_IOSAssignment
//
//  Created by Amsys on 02/02/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import UIKit

// global var
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {

    var lastURLUsedToLoadImage: String?

    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString

        self.image = nil

        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }

            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }

            guard let imageData = data else { return }

            let photoImage = UIImage(data: imageData)

            imageCache[url.absoluteString] = photoImage

            // update the UI
            DispatchQueue.main.async {
                self.image = photoImage
            }

            }.resume()
    }
}