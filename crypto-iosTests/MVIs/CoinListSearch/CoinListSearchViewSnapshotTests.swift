//
//  CoinListSearchViewSnapshotTests.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import XCTest
@testable import crypto_ios

class CoinListSearchViewSnapshotTests: SnapshotTestCase {

  var sut: CoinListSearchView!

  override func setUp() {
    super.setUp()
    sut = CoinListSearchView()
    sut.frame = UIScreen.main.bounds
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
    verifyViewWithTolerance(sut)
  }

  func testCoinDetailView_With_Details() {
    // when
    sut.update(with: CoinListSearchState(prevState: .initialState,
                                         hasNext: false,
                                         isLoading: false,
                                         isError: false,
                                         coins: [],
                                         coinViewModels: [CoinListCellViewModel(type: .coin,
                                                                                id: "test_id_1",
                                                                                title: "test_coin_1",
                                                                                symbol: "test_symbol",
                                                                                logoUrl: "test_logo_url",
                                                                                price: "test_price",
                                                                                change: "test_change",
                                                                                changeColor: UIColor.Text.green),
                                                          CoinListCellViewModel(type: .coin,
                                                                                id: "test_id_2",
                                                                                title: "test_coin_2",
                                                                                symbol: "test_symbol",
                                                                                logoUrl: "test_logo_url",
                                                                                price: "test_price",
                                                                                change: "test_change",
                                                                                changeColor: UIColor.Text.red),
                                                          CoinListCellViewModel(type: .coin,
                                                                                id: "test_id_3",
                                                                                title: "test_coin_3",
                                                                                symbol: "test_symbol",
                                                                                logoUrl: "test_logo_url",
                                                                                price: "test_price",
                                                                                change: "test_change",
                                                                                changeColor: UIColor.Text.green)]),
               prevState: .initialState)

    // then
    verifyViewWithTolerance(sut)
  }
}
