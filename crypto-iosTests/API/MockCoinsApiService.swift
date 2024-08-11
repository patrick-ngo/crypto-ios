//
//  MockCoinsApiService.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation
@testable import crypto_ios

final class MockCoinsApiService: CoinsApiService {
  var fetchCoinListResponse = CoinListResponse(status: "success",
                                               data: CoinListData(stats: Stats(total: 1,
                                                                               totalCoins: 1,
                                                                               totalMarkets: 1,
                                                                               totalExchanges: 1,
                                                                               totalMarketCap: "",
                                                                               total24hVolume: ""),
                                                                  coins: [Coin(uuid: "test_uuid",
                                                                               symbol: nil,
                                                                               name: nil,
                                                                               description: nil,
                                                                               color: nil,
                                                                               iconUrl: nil,
                                                                               websiteUrl: nil,
                                                                               marketCap: nil,
                                                                               price: nil,
                                                                               change: nil,
                                                                               rank: nil)]))
  var fetchCoinListCalled = false
  func fetchCoinList(for page: Int, pageSize: Int, 
                     searchText: String?,
                     completion: @escaping (Result<CoinListResponse, Error>) -> Void) {
    fetchCoinListCalled = true
    completion(.success(fetchCoinListResponse))
  }

  var fetchCoinDetailResponse = CoinDetailResponse(status: "success",
                                                   data: CoinDetailData(coin: Coin(uuid: "test_uuid",
                                                                                   symbol: nil,
                                                                                   name: nil,
                                                                                   description: nil,
                                                                                   color: nil,
                                                                                   iconUrl: nil,
                                                                                   websiteUrl: nil,
                                                                                   marketCap: nil,
                                                                                   price: nil,
                                                                                   change: nil,
                                                                                   rank: nil)))
  var fetchCoinDetailCalled = false
  func fetchCoinDetail(for coinId: String, 
                       completion: @escaping (Result<CoinDetailResponse, Error>) -> Void) {
    fetchCoinDetailCalled = true
    completion(.success(fetchCoinDetailResponse))
  }
}
