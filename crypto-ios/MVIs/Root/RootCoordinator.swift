//
//  RootCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
import CoreLocation

protocol RootCoordinatorInput: Coordinator {}

final class RootCoordinator: Coordinator,
                             RootCoordinatorInput {

  var rootNavigationController: UINavigationController = {
    let navigationController = UINavigationController(rootViewController: RootViewController())
    navigationController.setNavigationBarHidden(false, animated: false)
    navigationController.modalPresentationStyle = .overFullScreen
    return navigationController
  }()

  var childCoordinators = [Coordinator]()
  var keyWindow: UIWindow?
  let dependency: RootDependency

  init(keyWindow: UIWindow) {
    self.keyWindow = keyWindow
    let coinsApiService = CoinsApiServiceImp()
    dependency = RootDependencyImp(coinsApiService: coinsApiService)
  }

  func start() {
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(true, animated: false)
    navigationController.modalPresentationStyle = .overFullScreen
    keyWindow?.rootViewController = navigationController
    let windowLevel = (UIApplication.shared.currentWindow?.windowLevel ?? .normal) + 1
    keyWindow?.windowLevel = windowLevel
    keyWindow?.makeKeyAndVisible()

    navigationController.present(rootNavigationController, animated: false) {}
    attachCoinList()
  }

  func finish() {
    _ = rootNavigationController.popViewController(animated: false)
    self.keyWindow = nil
  }

  private func attachCoinList() {
    let coinListCoordinator = CoinListCoordinator(navigationController: rootNavigationController,
                                                   dependency: dependency)
    coinListCoordinator.parentCoordinator = self
    coinListCoordinator.start()
    childCoordinators.append(coinListCoordinator)
  }
}

private class RootViewController: UIViewController {}
