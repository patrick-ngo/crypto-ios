//
//  CoinListSearchCoordinatorTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListSearchCoordinatorTests: XCTestCase {

  enum Given {
    static let coin = Coin(uuid: "test_uuid",
                           symbol: nil,
                           name: nil,
                           description: nil,
                           color: nil,
                           iconUrl: nil,
                           websiteUrl: nil,
                           marketCap: nil,
                           price: nil,
                           change: nil,
                           rank: nil)
  }

  var sut: CoinListSearchCoordinator!
  var navigationController: MockUINavigationController!
  var parentCoordinator: MockCoordinator!
  var dependency: MockRootDependency!
  var containerView: UIView!
  var searchTextRelay: MutableBehaviorRelay<String>!

  override func setUp() {
    super.setUp()
    navigationController = MockUINavigationController()
    dependency = MockRootDependency()
    parentCoordinator = MockCoordinator()
    containerView = UIView()
    searchTextRelay = MutableBehaviorRelay(value: "")

    sut = CoinListSearchCoordinator(containerView: containerView,
                                    navigationController: navigationController,
                                    searchTextRelay: searchTextRelay,
                                    dependency: dependency)
    sut.parentCoordinator = parentCoordinator
  }

  override func tearDown() {
    sut = nil
    navigationController = nil
    parentCoordinator = nil
    super.tearDown()
  }

  func testStart() {
    // when
    sut.start()

    // then
    XCTAssertTrue(containerView.subviews.first is CoinListSearchView)
    XCTAssertFalse(containerView.isHidden)
  }

  func testFinish() {
    // when
    sut.finish()

    // then
    XCTAssertTrue(parentCoordinator.childDidFinishCalled)
    XCTAssertTrue(containerView.subviews.isEmpty)
    XCTAssertTrue(containerView.isHidden)
  }

  func testGoToMovieDetail() {
    // given
    let initialNumChildCoordinators = sut.childCoordinators.count

    // when
    sut.goToCoinDetail(with: Given.coin)

    // then
    XCTAssertEqual(sut.childCoordinators.count, initialNumChildCoordinators + 1)
    XCTAssertTrue(sut.childCoordinators.first is CoinDetailCoordinator)
    XCTAssertTrue(navigationController.presentViewController is CoinDetailViewController)
  }
}

