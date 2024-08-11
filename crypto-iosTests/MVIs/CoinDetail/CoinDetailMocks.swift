//
//  CoinDetailMocks.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
@testable import crypto_ios

enum CoinDetailMocks {

  class IntentMock: CoinDetailIntentInput {
    var bindCalled = false
    func bind<V: CoinDetailViewControllerInput>(to view: V) {
      bindCalled = true
    }

    var goBackCalled = false
    func goBack() {
      goBackCalled = true
    }

    var getCoinCalled = false
    func getCoin() {
      getCoinCalled = true
    }

    var goToWebsiteCalled = false
    func goToWebsite() {
      goToWebsiteCalled = true
    }
  }

  class ViewControllerMock: CoinDetailViewControllerInput {
    var state: CoinDetailState?
    var prevState: CoinDetailState?
    var updateCalled = false
    func update(with state: CoinDetailState, prevState: CoinDetailState?) {
      self.updateCalled = true
      self.state = state
      self.prevState = prevState
    }
  }

  class CoordinatorMock: CoinDetailCoordinatorInput {


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

    var goToWebsiteCalled = false
    var goToWebsiteUrl: String?
    func goToWebsite(with url: String) {
      goToWebsiteCalled = true
      goToWebsiteUrl = url
    }
  }
}
