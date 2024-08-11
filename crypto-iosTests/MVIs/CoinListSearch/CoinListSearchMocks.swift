//
//  CoinListSearchSearchMocks.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
@testable import crypto_ios

enum CoinListSearchMocks {

  class IntentMock: CoinListSearchIntentInput {

    var bindCalled = false
    func bind<V: CoinListSearchViewControllerInput>(to view: V) {
      bindCalled = true
    }

    var goBackCalled = false
    func goBack() {
      goBackCalled = true
    }

    var getCoinsCalled = false
    func getCoins() {
      getCoinsCalled = true
    }

    var getMoreCoinsCalled = false
    func getMoreCoins() {
      getMoreCoinsCalled = true
    }

    var goToCoinDetailCalled = false
    func goToCoinDetail(with index: Int) {
      goToCoinDetailCalled = true
    }
  }

  class ViewControllerMock: CoinListSearchViewControllerInput {
    var state: CoinListSearchState?
    var prevState: CoinListSearchState?
    var updateCalled = false
    func update(with state: CoinListSearchState, prevState: CoinListSearchState?) {
      self.updateCalled = true
      self.state = state
      self.prevState = prevState
    }
  }

  class CoordinatorMock: CoinListSearchCoordinatorInput {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()

    var startCalled = false
    func start() {
      startCalled = true
    }

    var finishCalled = false
    func finish() {
      finishCalled = true
    }

    var goToCoinDetailCalled = false
    func goToCoinDetail(with coin: Coin) {
      goToCoinDetailCalled = true
    }
  }
}
