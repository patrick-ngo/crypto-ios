//
//  Coin.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

struct CoinDetailResponse: Codable {
  let status: String
  let data: CoinDetailData
}

struct CoinDetailData: Codable {
  let coin: Coin
}

struct Coin: Codable {
  let uuid: String
  let symbol: String?
  let name: String?
  let description: String?
  let color: String?
  let iconUrl: String?
  let websiteUrl: String?
  let marketCap: String?
  let price: String?
  let change: String?
  let rank: Int?
}
