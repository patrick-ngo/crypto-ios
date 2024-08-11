//
//  CoinDetailIntent.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

protocol CoinDetailListener: AnyObject {}

protocol CoinDetailIntentInput {
  func bind<V: CoinDetailViewControllerInput>(to view: V)
  func goBack()
  func getCoin()
  func goToWebsite()
}

final class CoinDetailIntent: CoinDetailIntentInput {

  weak var coordinator: CoinDetailCoordinatorInput?
  private weak var listener: CoinDetailListener?
  private let coinsApiService: CoinsApiService
  private let coin: Coin
  private let stateDriver: StateDriver<CoinDetailState>
  private let disposeBag = DisposeBag()

  private var currentState: CoinDetailState {
    return stateDriver.value
  }

  init(coin: Coin,
       coinsApiService: CoinsApiService) {
    self.coinsApiService = coinsApiService
    self.coin = coin
    stateDriver = StateDriver<CoinDetailState>(value: CoinDetailState(prevState: CoinDetailState.initialState,
                                                                      coin: coin))
  }

  func bind<V: CoinDetailViewControllerInput>(to view: V) {
    stateDriver.bind(to: view)
      .disposed(by: disposeBag)
  }

  func goBack() {
    coordinator?.finish()
  }

  func goToWebsite() {
    guard let websiteUrl = currentState.websiteUrl else { return }
    coordinator?.goToWebsite(with: websiteUrl)
  }

  func getCoin() {
    updateState(from: coin)

    coinsApiService.fetchCoinDetail(for: coin.uuid) { [weak self] coinDetailResult in
      guard let this = self else { return }
      switch coinDetailResult {
      case .success(let coinDetailResponse):
        let coin = coinDetailResponse.data.coin
        this.updateState(from: coin)
      case .failure:
        this.stateDriver.accept(CoinDetailState(prevState: this.currentState))
      }
    }
  }

  private func updateState(from coin: Coin) {
    let displayedPrice = CurrencyFormatter.getDisplayedShortPrice(for: coin.price)
    let displayedMarketCap = CurrencyFormatter.getDisplayedMarketCap(marketCap: coin.marketCap)
    var nameColor = UIColor.Text.darkGrey
    if let color = coin.color {
      nameColor = UIColor(hexString: color)
    }
    stateDriver.accept(CoinDetailState(prevState: currentState,
                                       coin: coin,
                                       logoUrl: coin.iconUrl,
                                       name: coin.name,
                                       nameColor: nameColor,
                                       symbol: coin.symbol,
                                       price: displayedPrice,
                                       marketCap: displayedMarketCap,
                                       description: coin.description,
                                       websiteUrl: coin.websiteUrl))
  }
}

