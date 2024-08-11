//
//  CoinListSearchCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

protocol CoinListSearchCoordinatorInput: Coordinator {
  func goToCoinDetail(with movie: Coin)
}

final class CoinListSearchCoordinator: CoinListSearchCoordinatorInput {

  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()
  private let searchTextRelay: ReadonlyBehaviorRelay<String>
  private let containerView: UIView
  private let navigationController: UINavigationController
  private let dependency: RootDependency

  init(containerView: UIView,
       navigationController: UINavigationController,
       searchTextRelay: ReadonlyBehaviorRelay<String>,
       dependency: RootDependency) {
    self.containerView = containerView
    self.navigationController = navigationController
    self.searchTextRelay = searchTextRelay
    self.dependency = dependency
  }

  func start() {
    let view = CoinListSearchView()

    let intent = CoinListSearchIntent(coinsApiService: dependency.coinsApiService,
                                      searchTextRelay: searchTextRelay)
    intent.coordinator = self
    view.intent = intent

    containerView.addSubview(view)
    view.snp.makeConstraints { make in
      make.edges.equalTo(containerView)
    }
    containerView.isHidden = false
  }

  func finish() {
    containerView.subviews.forEach { view in
      view.removeFromSuperview()
    }
    containerView.isHidden = true
    parentCoordinator?.childDidFinish(child: self)
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
}
