//
//  MockUINavigationController.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
@testable import crypto_ios

class MockUINavigationController: UINavigationController {

  var presentCalled = false
  var presentViewController: UIViewController?
  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    super.present(viewControllerToPresent, animated: flag, completion: completion)
    presentCalled = true
    presentViewController = viewControllerToPresent
  }

  var pushCalled = false
  var pushViewController: UIViewController?
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    pushCalled = true
    pushViewController = viewController
  }

  var dismissCalled = false
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    dismissCalled = true
  }

  var popCalled = false
  override func popViewController(animated: Bool) -> UIViewController? {
    popCalled = true
    return super.popViewController(animated: animated)
  }
}

class MockUIViewController: UIViewController {

  var addChildCalled = false
  override func addChild(_ childController: UIViewController) {
    addChildCalled = true
  }

  var removeFromParentCalled = false
  override func removeFromParent() {
    removeFromParentCalled = true
  }
}
