//
//  UIApplication+Extension.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

extension UIApplication {
  var currentWindow: UIWindow? {
    return UIApplication.shared.windows.first { $0.isKeyWindow }
  }
}
