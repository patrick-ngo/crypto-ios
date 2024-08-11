//
//  MovieListViewTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListViewTests: XCTestCase {

  var sut: CoinListViewController!
  var intent: CoinListMocks.IntentMock!

  override func setUp() {
    super.setUp()
    sut = CoinListViewController()
    intent = CoinListMocks.IntentMock()
    sut.intent = intent
  }

  override func tearDown() {
    sut = nil
    intent = nil
    super.tearDown()
  }
  
  func testViewDidLoad() {
    // when
    sut.viewDidLoad()

    // then
    XCTAssertTrue(intent.getCoinsCalled)
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

  func testOnTopCoinCellTapped() {
    // when
    sut.onTopCoinCellTapped(with: 0)

    // then
    XCTAssertTrue(intent.goToTopCoinDetailCalled)
  }

  func testOnRetryButtonTapped() {
    // when
    sut.onRetryButtonTapped()

    // then
    XCTAssertTrue(intent.getCoinsCalled)
  }

  func testOnSearchTextChanged() {
    // when
    sut.onSearchTextChanged(with: "test_search_text")

    // then
    XCTAssertTrue(intent.updateSearchCalled)
  }
}
