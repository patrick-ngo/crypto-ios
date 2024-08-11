//
//  CoinListMocks.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
@testable import crypto_ios

enum CoinListMocks {

  class IntentMock: CoinListIntentInput {

    var bindCalled = false
    func bind<V: CoinListViewControllerInput>(to view: V) {
      bindCalled = true
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

    var goToTopCoinDetailCalled = false
    func goToTopCoinDetail(with index: Int) {
      goToTopCoinDetailCalled = true
    }

    var updateSearchCalled = false
    var updateSearchText: String?
    var updateSearchContainerView: UIView?
    func updateSearch(with searchText: String, containerView: UIView) {
      updateSearchCalled = true
      updateSearchText = searchText
      updateSearchContainerView = containerView
    }

  }

  class ViewControllerMock: CoinListViewControllerInput {
    var state: CoinListState?
    var prevState: CoinListState?
    var updateCalled = false
    func update(with state: CoinListState, prevState: CoinListState?) {
      self.updateCalled = true
      self.state = state
      self.prevState = prevState
    }
  }

  class CoordinatorMock: CoinListCoordinatorInput {

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

    var attachSearchViewIfNeededCalled = false
    var attachSearchTextRelay: ReadonlyBehaviorRelay<String>?
    var attachSearchContainerView: UIView?
    func attachSearchViewIfNeeded(with searchTextRelay: ReadonlyBehaviorRelay<String>,
                                  containerView: UIView) {
      attachSearchViewIfNeededCalled = true
      attachSearchTextRelay = searchTextRelay
      attachSearchContainerView = containerView
    }
  }
}
