//
//  CoinListSearchState.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation

struct CoinListSearchState: State {

  static let initialState = CoinListSearchState(hasNext: true,
                                                page: 0,
                                                isLoading: true,
                                                isError: false,
                                                coins: [],
                                                coinViewModels: [])
  var hasNext = false
  var page = 0
  var isLoading = false
  var isError = false
  var coins: [Coin] = []
  var coinViewModels: [CoinListCellViewModel]

  var isEmptySearchResult: Bool {
    return coinViewModels.isEmpty
  }
}

extension CoinListSearchState {

  init(prevState: CoinListSearchState,
       hasNext: Bool? = nil,
       page: Int? = nil,
       isLoading: Bool? = nil,
       isError: Bool? = nil,
       coins: [Coin]? = nil,
       coinViewModels: [CoinListCellViewModel]? = nil) {
    self.hasNext = hasNext ?? prevState.hasNext
    self.page = page ?? prevState.page
    self.isLoading = isLoading ?? prevState.isLoading
    self.isError = isError ?? prevState.isError
    self.coins = coins ?? prevState.coins
    self.coinViewModels = coinViewModels ?? prevState.coinViewModels
  }
}
