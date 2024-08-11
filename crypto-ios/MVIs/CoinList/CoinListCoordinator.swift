//
//  CoinListCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

protocol CoinListCoordinatorInput: Coordinator {
  func goToCoinDetail(with movie: Coin)
  func attachSearchViewIfNeeded(with searchTextRelay: ReadonlyBehaviorRelay<String>,
                                containerView: UIView)
  func attachShareSheet()
}

final class CoinListCoordinator: CoinListCoordinatorInput {

  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()
  private let navigationController: UINavigationController
  private let dependency: RootDependency

  init(navigationController: UINavigationController,
       dependency: RootDependency) {
    self.navigationController = navigationController
    self.dependency = dependency
  }

  func start() {
    let viewController = CoinListViewController()
    let intent = CoinListIntent(coinsApiService: dependency.coinsApiService)
    intent.coordinator = self
    viewController.intent = intent
    navigationController.viewControllers = [viewController]
  }

  func finish() {
    parentCoordinator?.childDidFinish(child: self)
    parentCoordinator?.finish()
  }

  func goToCoinDetail(with coin: Coin) {
    let coinDetailCoordinator = CoinDetailCoordinator(navigationController: navigationController,
                                                      dependency: dependency,
                                                      application: UIApplication.shared,
                                                      coin: coin)
    coinDetailCoordinator.parentCoordinator = self
    coinDetailCoordinator.start()
    childCoordinators.append(coinDetailCoordinator)
  }

  func attachSearchViewIfNeeded(with searchTextRelay: ReadonlyBehaviorRelay<String>,
                                containerView: UIView) {
    guard containerView.isHidden else { return }
    let coinListSearchCoordinator = CoinListSearchCoordinator(containerView: containerView,
                                                              navigationController: navigationController,
                                                              searchTextRelay: searchTextRelay,
                                                              dependency: dependency)
    coinListSearchCoordinator.parentCoordinator = self
    coinListSearchCoordinator.start()
    childCoordinators.append(coinListSearchCoordinator)
  }

  func attachShareSheet() {
    let textToShare = "Check out my awesome crypto app!"
    let urlToShare = URL(string: "https://www.linkedin.com/in/patngo")!
    let items: [Any] = [textToShare, urlToShare]
    let activityViewController = UIActivityViewController(activityItems: items, 
                                                          applicationActivities: nil)
    navigationController.present(activityViewController, animated: true, completion: nil)
  }
}

