//
//  CoinDetailState.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

struct CoinDetailState: State {

  static let initialState = CoinDetailState(coin: nil,
                                            logoUrl: "",
                                            name: "",
                                            nameColor: nil,
                                            symbol: "",
                                            price: "",
                                            marketCap: "",
                                            description: "",
                                            websiteUrl: nil)

  var coin: Coin? = nil
  var logoUrl: String = ""
  var name: String = ""
  var nameColor: UIColor? = nil
  var symbol: String = ""
  var price: String = ""
  var marketCap: String = ""
  var description: String = ""
  var websiteUrl: String? = nil
}

extension CoinDetailState {

  init(prevState: CoinDetailState,
       coin: Coin? = nil,
       logoUrl: String? = nil,
       name: String? = nil,
       nameColor: UIColor? = nil,
       symbol: String? = nil,
       price: String? = nil,
       marketCap: String? = nil,
       description: String? = nil,
       websiteUrl: String? = nil) {
    self.coin = coin ?? prevState.coin
    self.logoUrl = logoUrl ?? prevState.logoUrl
    self.name = name ?? prevState.name
    self.nameColor = nameColor ?? prevState.nameColor
    self.symbol = symbol ?? prevState.symbol
    self.price = price ?? prevState.price
    self.marketCap = marketCap ?? prevState.marketCap
    self.description = description ?? prevState.description
    self.websiteUrl = websiteUrl ?? prevState.websiteUrl
  }
}
