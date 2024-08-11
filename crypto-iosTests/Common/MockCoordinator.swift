//
//  MockCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation
import UIKit
@testable import crypto_ios

class MockCoordinator: Coordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = UINavigationController()

  var childDidFinishCalled = false
  func childDidFinish(child: Coordinator) {
    childDidFinishCalled = true
  }

  var startCalled = false
  func start() {
    startCalled = true
  }

  var finishCalled = false
  func finish() {
    finishCalled = true
  }
}
