//
//  CoinListSearchIntentTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListSearchIntentTests: XCTestCase {

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

  var sut: CoinListSearchIntent!
  var coordinator: CoinListSearchMocks.CoordinatorMock!
  var view: CoinListSearchMocks.ViewControllerMock!
  var coinsApiService: MockCoinsApiService!
  var searchTextRelay: MutableBehaviorRelay<String>!

  override func setUp() {
    super.setUp()
    coordinator = CoinListSearchMocks.CoordinatorMock()
    view = CoinListSearchMocks.ViewControllerMock()
    coinsApiService = MockCoinsApiService()
    searchTextRelay = MutableBehaviorRelay(value: "")
    sut = CoinListSearchIntent(coinsApiService: coinsApiService,
                               searchTextRelay: searchTextRelay)
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

  func testGetCoins() {
    // given
    sut.bind(to: view)

    // when
    sut.getCoins()

    // then
    XCTAssertTrue(coinsApiService.fetchCoinListCalled)
  }

  func testGetMoreCoins() {
    // given
    sut.bind(to: view)

    // when
    sut.getMoreCoins()

    // then
    XCTAssertTrue(coinsApiService.fetchCoinListCalled)
  }

  func testGoToCoinDetailCalled() {
    // given
    sut.bind(to: view)
    coinsApiService.fetchCoinListResponse = CoinListResponse(
      status: "success",
      data: CoinListData(stats: Stats(total: 1,
                                      totalCoins: 1,
                                      totalMarkets: 1,
                                      totalExchanges: 1,
                                      totalMarketCap: "",
                                      total24hVolume: ""),
                         coins: [Coin(uuid: "test_uuid_1",
                                      symbol: "test_symbol",
                                      name: "test_name",
                                      description: "test_description",
                                      color: "test_color",
                                      iconUrl: "test_icon_url",
                                      websiteUrl: "test_website_url",
                                      marketCap: "test_market_cap",
                                      price: "100.12",
                                      change: "test_change",
                                      rank: 1)
                         ]))
    sut.getCoins()

    // when
    sut.goToCoinDetail(with: 0)

    // then
    XCTAssertTrue(coordinator.goToCoinDetailCalled)
  }
}
