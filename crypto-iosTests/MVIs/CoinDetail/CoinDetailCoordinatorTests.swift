//
//  MovieDetailCoordinatorTests.swift
//  movies-iosTests
//
//  Created by Patrick Ngo on 2022-05-02.
//  Copyright © 2022 patrickngo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import crypto_ios

class CoinDetailCoordinatorTests: XCTestCase {

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

  var sut: CoinDetailCoordinator!
  var navigationController: MockUINavigationController!
  var parentCoordinator: MockCoordinator!
  var dependency: MockRootDependency!
  var application: UIApplication!

  override func setUp() {
    super.setUp()
    navigationController = MockUINavigationController()
    dependency = MockRootDependency()
    parentCoordinator = MockCoordinator()
    application = UIApplication.shared
    sut = CoinDetailCoordinator(navigationController: navigationController,
                                dependency: dependency,
                                application: application,
                                coin: Given.coin)
    sut.parentCoordinator = parentCoordinator
  }

  override func tearDown() {
    sut = nil
    navigationController = nil
    parentCoordinator = nil
    application = nil
    super.tearDown()
  }

  func testStart() {
    // when
    sut.start()

    // then
    XCTAssertTrue(navigationController.presentViewController is CoinDetailViewController)
  }

  func testFinish() {
    // when
    sut.finish()

    // then
    XCTAssertTrue(parentCoordinator.childDidFinishCalled)
    XCTAssertTrue(navigationController.dismissCalled)
  }
}
