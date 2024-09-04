//
//  UIImageView+LoadImage.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching image: \(String(describing: error))")
                return
            }
            
            // Convert the data into a UIImage object and update the UIImageView
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
