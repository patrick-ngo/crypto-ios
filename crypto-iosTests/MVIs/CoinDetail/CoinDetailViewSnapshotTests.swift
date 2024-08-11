//
//  CoinDetailViewSnapshotTests.swift //
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinDetailViewSnapshotTests: SnapshotTestCase {

  var sut: CoinDetailViewController!

  override func setUp() {
    super.setUp()
    sut = CoinDetailViewController()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testCoinDetailView_With_InitialState() {
    // when
    sut.update(with: .initialState,
               prevState: nil)

    // then
    verifyViewControllerWithTolerance(sut)
  }

  func testCoinDetailView_With_Details() {
    // when
    sut.update(with: CoinDetailState(prevState: .initialState,
                                     coin: nil,
                                     logoUrl: "",
                                     name: "test_name",
                                     nameColor: UIColor.Text.green,
                                     symbol: "test_symbol",
                                     price: "test_price",
                                     marketCap: "test_market_cap",
                                     description: "test_description",
                                     websiteUrl: "test_website_url"),
               prevState: .initialState)

    // then
    verifyViewControllerWithTolerance(sut)
  }
}
