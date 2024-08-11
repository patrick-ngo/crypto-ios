//
//  MovieListCoordinator.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListCoordinatorTests: XCTestCase {
  
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
  
  var sut: CoinListCoordinator!
  var navigationController: MockUINavigationController!
  var parentCoordinator: MockCoordinator!
  var dependency: MockRootDependency!
  
  override func setUp() {
    super.setUp()
    navigationController = MockUINavigationController()
    dependency = MockRootDependency()
    parentCoordinator = MockCoordinator()
    sut = CoinListCoordinator(navigationController: navigationController,
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
    XCTAssertTrue(navigationController.topViewController is CoinListViewController)
  }
  
  func testFinish() {
    // when
    sut.finish()
    
    // then
    XCTAssertTrue(parentCoordinator.childDidFinishCalled)
    XCTAssertTrue(parentCoordinator.finishCalled)
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

  func testAttachSearchViewIfNeeded() {
    // given
    let initialNumChildCoordinators = sut.childCoordinators.count
    let containerView = UIView()
    containerView.isHidden = true
    let searchTextRelay = MutableBehaviorRelay(value: "")

    // when
    sut.attachSearchViewIfNeeded(with: searchTextRelay, 
                                 containerView: containerView)

    // then
    XCTAssertEqual(sut.childCoordinators.count, initialNumChildCoordinators + 1)
    XCTAssertTrue(sut.childCoordinators.first is CoinListSearchCoordinator)
    XCTAssertTrue(containerView.subviews.first is CoinListSearchView)
  }

  func testAttachSearchViewIfNeeded_When_SearchViewAlreadyShown() {
    // given
    let initialNumChildCoordinators = sut.childCoordinators.count
    let containerView = UIView()
    containerView.isHidden = false
    let searchTextRelay = MutableBehaviorRelay(value: "")

    // when
    sut.attachSearchViewIfNeeded(with: searchTextRelay,
                                 containerView: containerView)

    // then
    XCTAssertNotEqual(sut.childCoordinators.count, initialNumChildCoordinators + 1)
    XCTAssertFalse(sut.childCoordinators.first is CoinListSearchCoordinator)
    XCTAssertFalse(containerView.subviews.first is CoinListSearchView)
  }

  func testAttachShareSheet() {
    // when
    sut.attachShareSheet()

    // then
    XCTAssertTrue(navigationController.presentViewController is UIActivityViewController)
  }
}

