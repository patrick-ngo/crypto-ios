//
//  CoinListState.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation

struct CoinListState: State {

  static let initialState = CoinListState(hasNext: true,
                                          page: 0,
                                          isLoading: true,
                                          isError: false,
                                          inviteFriendPosition: 5,
                                          coinsDict: [:],
                                          topCoinViewModels: [],
                                          coinViewModels: [])
  var hasNext = false
  var page = 0
  var isLoading = false
  var isError = false
  var inviteFriendPosition = 0
  var coinsDict: [String: Coin] = [:]
  var topCoinViewModels: [CoinListCellViewModel] = []
  var coinViewModels: [CoinListCellViewModel]


  var isInitialLoading: Bool {
    return coinViewModels.isEmpty
  }
}

extension CoinListState {

  init(prevState: CoinListState,
       hasNext: Bool? = nil,
       page: Int? = nil,
       isLoading: Bool? = nil,
       isError: Bool? = nil,
       inviteFriendPosition: Int? = nil,
       coinsDict: [String: Coin]? = nil,
       topCoins: [Coin]? = nil,
       topCoinViewModels: [CoinListCellViewModel]? = nil,
       coins: [Coin]? = nil,
       coinViewModels: [CoinListCellViewModel]? = nil) {
    self.hasNext = hasNext ?? prevState.hasNext
    self.page = page ?? prevState.page
    self.isLoading = isLoading ?? prevState.isLoading
    self.isError = isError ?? prevState.isError
    self.inviteFriendPosition = inviteFriendPosition ?? prevState.inviteFriendPosition
    self.coinsDict = coinsDict ?? prevState.coinsDict
    self.topCoinViewModels = topCoinViewModels ?? prevState.topCoinViewModels
    self.coinViewModels = coinViewModels ?? prevState.coinViewModels
  }
}
