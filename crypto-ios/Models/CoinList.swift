//
//  CoinList.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

struct CoinListResponse: Codable {
  let status: String
  let data: CoinListData
}

struct CoinListData: Codable {
  let stats: Stats?
  let coins: [Coin]?
}

struct Stats: Codable {
  let total: Int
  let totalCoins: Int
  let totalMarkets: Int
  let totalExchanges: Int
  let totalMarketCap: String
  let total24hVolume: String
}
