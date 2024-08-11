//
//  MovieListIntentTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListIntentTests: XCTestCase {

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

  var sut: CoinListIntent!
  var coordinator: CoinListMocks.CoordinatorMock!
  var view: CoinListMocks.ViewControllerMock!
  var coinsApiService: MockCoinsApiService!
  var searchTextRelay: MutableBehaviorRelay<String>!

  override func setUp() {
    super.setUp()
    coordinator = CoinListMocks.CoordinatorMock()
    view = CoinListMocks.ViewControllerMock()
    coinsApiService = MockCoinsApiService()
    searchTextRelay = MutableBehaviorRelay(value: "")
    sut = CoinListIntent(coinsApiService: coinsApiService,
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

  func testUpdateSearch() {
    // given
    let containerView = UIView()
    sut.bind(to: view)

    // when
    sut.updateSearch(with: "test_search_text",
                     containerView: containerView)

    // then
    XCTAssertTrue(coordinator.attachSearchViewIfNeededCalled)
    XCTAssertEqual(searchTextRelay.value, "test_search_text")
  }

  func testUpdateSearch_When_SearchTextEmpty() {
    // given
    let containerView = UIView()
    sut.bind(to: view)

    // when
    sut.updateSearch(with: "",
                     containerView: containerView)

    // then
    XCTAssertFalse(coordinator.attachSearchViewIfNeededCalled)
    XCTAssertEqual(searchTextRelay.value, "")
  }

  func testGoToTopCoinDetailCalled() {
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
                         coins: [Coin(uuid: "test_uuid",
                                      symbol: "test_symbol",
                                      name: "test_name",
                                      description: "test_description",
                                      color: "test_color",
                                      iconUrl: "test_icon_url",
                                      websiteUrl: "test_website_url",
                                      marketCap: "test_market_cap",
                                      price: "100.12",
                                      change: "test_change",
                                      rank: 1)]))
    sut.getCoins()

    // when
    sut.goToTopCoinDetail(with: 0)

    // then
    XCTAssertTrue(coordinator.goToCoinDetailCalled)
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
                                      rank: 1),
                                 Coin(uuid: "test_uuid_2",
                                              symbol: "test_symbol",
                                              name: "test_name",
                                              description: "test_description",
                                              color: "test_color",
                                              iconUrl: "test_icon_url",
                                              websiteUrl: "test_website_url",
                                              marketCap: "test_market_cap",
                                              price: "100.12",
                                              change: "test_change",
                                              rank: 1),
                                 Coin(uuid: "test_uuid_3",
                                              symbol: "test_symbol",
                                              name: "test_name",
                                              description: "test_description",
                                              color: "test_color",
                                              iconUrl: "test_icon_url",
                                              websiteUrl: "test_website_url",
                                              marketCap: "test_market_cap",
                                              price: "100.12",
                                              change: "test_change",
                                              rank: 1),
                                 Coin(uuid: "test_uuid_4",
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

  func testGoToCoinDetailCalled_When_LessThan4Coins() {
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
    XCTAssertFalse(coordinator.goToCoinDetailCalled)
  }
}
