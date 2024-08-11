//
//  UIImageView+Extension.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGKitPlugin

extension UIImageView {
  func loadImage(with url: String?,
                   svgImageSize: CGSize = CGSize(width: 40, height: 40)) {
    guard let url else { return }
    let imageURL = URL(string: url)
    let fileExtension = imageURL?.pathExtension.lowercased()

    switch fileExtension {
    case "svg":
      // Load SVG image
      sd_setImage(with: imageURL, placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : svgImageSize])
    default:
      // Load PNG or other bitmap image
      sd_setImage(with: imageURL)
    }
  }
}
