//
//  CoinListSearchViewTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListSearchViewTests: XCTestCase {

  var sut: CoinListSearchView!
  var intent: CoinListSearchMocks.IntentMock!

  override func setUp() {
    super.setUp()
    sut = CoinListSearchView()
    intent = CoinListSearchMocks.IntentMock()
    sut.intent = intent
  }

  override func tearDown() {
    sut = nil
    intent = nil
    super.tearDown()
  }

  func testOnViewAttached() {
    // when
    let containerView = UIView()
    containerView.addSubview(sut)

    // then
    XCTAssertTrue(intent.bindCalled)
  }

  func testOnRefreshPulled() {
    // when
    sut.onRefreshPulled()

    // then
    XCTAssertTrue(intent.getCoinsCalled)
  }

  func testOnEndOfListReached() {
    // when
    sut.onEndOfListReached()

    // then
    XCTAssertTrue(intent.getMoreCoinsCalled)
  }

  func testOnCoinCellTapped() {
    // when
    sut.onCoinCellTapped(with: 0)

    // then
    XCTAssertTrue(intent.goToCoinDetailCalled)
  }

  func testOnRetryButtonTapped() {
    // when
    sut.onRetryButtonTapped()

    // then
    XCTAssertTrue(intent.getCoinsCalled)
  }
}
