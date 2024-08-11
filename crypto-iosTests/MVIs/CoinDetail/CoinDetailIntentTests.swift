//
//  CoinDetailIntentTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import crypto_ios

class CoinDetailIntentTests: XCTestCase {

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

  var sut: CoinDetailIntent!
  var coordinator: CoinDetailMocks.CoordinatorMock!
  var view: CoinDetailMocks.ViewControllerMock!
  var coinsApiService: MockCoinsApiService!

  override func setUp() {
    super.setUp()
    coordinator = CoinDetailMocks.CoordinatorMock()
    view = CoinDetailMocks.ViewControllerMock()
    coinsApiService = MockCoinsApiService()
    sut = CoinDetailIntent(coin: Given.coin,
                           coinsApiService: coinsApiService)
    sut.coordinator = coordinator
  }

  override func tearDown() {
    sut = nil
    coordinator = nil
    view = nil
    coinsApiService = nil
    super.tearDown()
  }

  func testUpdate() {
    // when
    sut.bind(to: view)

    // then
    XCTAssertTrue(view.updateCalled)
  }

  func testGoBack() {
    // given
    sut.bind(to: view)

    // when
    sut.goBack()

    // then
    XCTAssertTrue(coordinator.finishCalled)
  }

  func testGetCoin() {
    // given
    sut.bind(to: view)
    coinsApiService.fetchCoinDetailResponse = CoinDetailResponse(
      status: "success",
      data: CoinDetailData(coin: Coin(uuid: "test_uuid",
                                      symbol: "test_symbol",
                                      name: "test_name",
                                      description: "test_description",
                                      color: "test_color",
                                      iconUrl: "test_icon_url",
                                      websiteUrl: "test_website_url",
                                      marketCap: "test_market_cap",
                                      price: "100.12",
                                      change: "test_change",
                                      rank: 1)))

    // when
    sut.getCoin()

    // then
    XCTAssertEqual(view.state?.name, "test_name")
    XCTAssertEqual(view.state?.description, "test_description")
    XCTAssertEqual(view.state?.websiteUrl, "test_website_url")
    XCTAssertEqual(view.state?.logoUrl, "test_icon_url")
    XCTAssertEqual(view.state?.price, "$ 100.12")
    XCTAssertEqual(view.state?.symbol, "test_symbol")
  }

  func testGoToWebsite() {
    // given
    sut.bind(to: view)
    coinsApiService.fetchCoinDetailResponse = CoinDetailResponse(
      status: "success",
      data: CoinDetailData(coin: Coin(uuid: "test_uuid",
                                      symbol: "test_symbol",
                                      name: "test_name",
                                      description: "test_description",
                                      color: "test_color",
                                      iconUrl: "test_icon_url",
                                      websiteUrl: "test_website_url",
                                      marketCap: "test_market_cap",
                                      price: "100.12",
                                      change: "test_change",
                                      rank: 1)))
    sut.getCoin()

    // when
    sut.goToWebsite()

    // then
    XCTAssertTrue(coordinator.goToWebsiteCalled)
    XCTAssertEqual(coordinator.goToWebsiteUrl, "test_website_url")
  }
}
