//
//  CoinDetailCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

protocol CoinDetailCoordinatorInput: Coordinator {
  func goToWebsite(with url: String)
}

final class CoinDetailCoordinator: CoinDetailCoordinatorInput {

  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()
  private let navigationController: UINavigationController
  private let dependency: RootDependency
  private let coin: Coin
  private let application: UIApplication

  init(navigationController: UINavigationController,
       dependency: RootDependency,
       application: UIApplication,
       coin: Coin) {
    self.navigationController = navigationController
    self.dependency = dependency
    self.application = application
    self.coin = coin
  }

  func start() {
    let viewController = CoinDetailViewController()
    let intent = CoinDetailIntent(coin: coin,
                                  coinsApiService: dependency.coinsApiService)
    intent.coordinator = self
    viewController.intent = intent
    navigationController.present(viewController, animated: true)
  }

  func finish() {
    navigationController.dismiss(animated: true)
    parentCoordinator?.childDidFinish(child: self)
  }

  func goToWebsite(with url: String) {
    guard let url = URL(string: url) else { return }
    application.open(url)
  }
}
