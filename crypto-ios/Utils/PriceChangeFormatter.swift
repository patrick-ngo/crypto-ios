//
//  PriceChangeFormatter.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

struct PriceChangeFormatter {

  static func getDisplayedchange(for change: String?) -> (change: String, color: UIColor) {
    guard let change else { return (change: "", color: UIColor.Text.green) }

    if let changeValue = Double(change) {
      let arrow = changeValue > 0 ? "↑" : "↓"
      let changeColor = changeValue > 0 ? UIColor.Text.green : UIColor.Text.red
      return (change: "\(arrow) \(change)", color: changeColor)
    }
    return (change: "", color: UIColor.Text.green)
  }
}
