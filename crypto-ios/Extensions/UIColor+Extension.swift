//
//  UIColor+Hex.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

extension UIColor {

  struct Text {
    static let darkGrey = UIColor(hex: 0x333333)
    static let lightGrey = UIColor(hex: 0x999999)
    static let placeholderGrey = UIColor(hex: 0xC4C4C4)
    static let green = UIColor(hex: 0x55B941)
    static let red = UIColor(hex: 0xE4433A)
    static let blue = UIColor(hex: 0x38A0FF)
  }

  struct Border {
    static let around = UIColor(hex: 0xF1F1F1)
  }

  struct Background {
    static let grey = UIColor(hex: 0xF9F9F9)
    static let white = UIColor(hex: 0xFFFFFF)
    static let searchGrey = UIColor(hex: 0xEEEEEE)
  }

  convenience init(hexString: String) {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0

    if hexString.hasPrefix("#") {
      let index: String.Index = hexString.index(hexString.startIndex, offsetBy: 1)
      let hex: String = String(hexString[index...])
      let scanner: Scanner = Scanner(string: hex)
      var hexValue: CUnsignedLongLong = 0
      if scanner.scanHexInt64(&hexValue) {
        switch hex.count {
        case 3:
          red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
          green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
          blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
          red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
          green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
          blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
          alpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6:
          red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
          green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
          blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
          red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
          green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
          blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
          alpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
          break
        }
      }
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  convenience init(hex: Int) {
    self.init(red: (CGFloat((hex & 0xff0000) >> 16)) / 255.0, 
              green: (CGFloat((hex & 0xff00) >> 8)) / 255.0,
              blue: (CGFloat(hex & 0xff)) / 255.0, 
              alpha: 1.0)
  }
}
