//
//  MovieDetailViewTests.swift
//  movies-iosTests
//
//  Created by Patrick Ngo on 2022-05-02.
//  Copyright © 2022 patrickngo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import crypto_ios

class CoinDetailViewTests: XCTestCase {

  var sut: CoinDetailViewController!
  var intent: CoinDetailMocks.IntentMock!

  override func setUp() {
    super.setUp()
    sut = CoinDetailViewController()
    intent = CoinDetailMocks.IntentMock()
    sut.intent = intent
  }

  override func tearDown() {
    sut = nil
    intent = nil
    super.tearDown()
  }

  func testOnViewDidLoad() {
    // when
    sut.viewDidLoad()

    // then
    XCTAssertTrue(intent.getCoinCalled)
  }

  func testBackButtonTapped() {
    // when
    sut.onBackButtonTapped()

    // then
    XCTAssertTrue(intent.goBackCalled)
  }


  func testGoToWebsite() {
    // when
    sut.onWebsiteButtonTapped()

    // then
    XCTAssertTrue(intent.goToWebsiteCalled)
  }
}
