//
//  UIImageView.swift
//  TMDb
//
//  Created by Lucas Santos on 05/04/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(url: URL, callback: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
                if let callback = callback {
                    callback(image)
                }
            } catch {
                print("Error downloading image: \(url)")
            }
        }
    }
}
