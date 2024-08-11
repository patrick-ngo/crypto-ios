//
//  CoinListSearchIntent.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

protocol CoinListSearchListener: AnyObject {}

protocol CoinListSearchIntentInput {
  func bind<V: CoinListSearchViewControllerInput>(to view: V)
  func getCoins()
  func getMoreCoins()
  func goToCoinDetail(with index: Int)
  func goBack()
}

final class CoinListSearchIntent: CoinListSearchIntentInput {

  private enum Constants {
    static let firstPage = 0
    static let pageSize = 50
  }

  weak var coordinator: CoinListSearchCoordinatorInput?
  private weak var listener: CoinListListener?
  private let coinsApiService: CoinsApiService
  private let searchTextRelay: ReadonlyBehaviorRelay<String>
  private let stateDriver: StateDriver<CoinListSearchState>
  private let disposeBag = DisposeBag()
  private let scheduler: SchedulerType

  private var currentState: CoinListSearchState {
    return stateDriver.value
  }

  init(coinsApiService: CoinsApiService,
       searchTextRelay: ReadonlyBehaviorRelay<String>,
       scheduler: SchedulerType = MainScheduler.instance) {
    self.coinsApiService = coinsApiService
    self.searchTextRelay = searchTextRelay
    self.scheduler = scheduler
    stateDriver = StateDriver<CoinListSearchState>(value: CoinListSearchState(prevState: CoinListSearchState.initialState))
    setupBindings()
  }

  func bind<V: CoinListSearchViewControllerInput>(to view: V) {
    stateDriver.bind(to: view)
      .disposed(by: disposeBag)

    getCoins()
  }

  private func setupBindings() {
    searchTextRelay
      .debounce(.milliseconds(300), 
                scheduler: scheduler)
      .distinctUntilChanged()
      .filter{ !$0.isEmpty }
      .subscribe(onNext: { [weak self] searchText in
        self?.getCoins()
      })
      .disposed(by: disposeBag)

    searchTextRelay
      .distinctUntilChanged()
      .filter{ $0.isEmpty }
      .observeOn(scheduler)
      .subscribe(onNext: { [weak self] searchText in
        self?.goBack()
      })
      .disposed(by: disposeBag)
  }

  func goToCoinDetail(with index: Int) {
    let selectedCoin = currentState.coins[index]
    coordinator?.goToCoinDetail(with: selectedCoin)
  }

  func getCoins() {
    fetchCoins(for: Constants.firstPage)
  }

  func getMoreCoins() {
    let nextPage = currentState.page + 1
    fetchCoins(for: nextPage)
  }

  func goBack() {
    coordinator?.finish()
  }

  private func fetchCoins(for page: Int) {
    let searchText = searchTextRelay.value
    stateDriver.accept(CoinListSearchState(prevState: currentState,
                                           isLoading: true))

    coinsApiService.fetchCoinList(for: page,
                                  pageSize: Constants.pageSize,
                                  searchText: searchText) { [weak self] coinListResult in
      guard let this = self else { return }
      switch coinListResult {
      case .success(let coinListResponse):
        if let coins = coinListResponse.data.coins,
           let totalCount = coinListResponse.data.stats?.total {
          let hasNext = this.calculateHasNext(with: totalCount, currentPage: page)
          let updatedCoins = page == Constants.firstPage ? coins : this.currentState.coins + coins
          let coinViewModels = coins.map { coin -> CoinListCellViewModel in
            let displayedPrice = CurrencyFormatter.getDisplayedPrice(for: coin.price)
            let displayedChange = PriceChangeFormatter.getDisplayedchange(for: coin.change)

            return CoinListCellViewModel(title: coin.name,
                                         symbol: coin.symbol,
                                         logoUrl: coin.iconUrl,
                                         price: displayedPrice,
                                         change: displayedChange.change,
                                         changeColor: displayedChange.color)
          }


          let updatedCoinViewModels = page == Constants.firstPage ? coinViewModels : this.currentState.coinViewModels + coinViewModels
          this.stateDriver.accept(CoinListSearchState(prevState: this.currentState,
                                                      hasNext: hasNext,
                                                      page: page,
                                                      isLoading: false,
                                                      isError: false,
                                                      coins: updatedCoins,
                                                      coinViewModels: updatedCoinViewModels))
        }
      case .failure:
        this.stateDriver.accept(CoinListSearchState(prevState: this.currentState,
                                                    isLoading: false,
                                                    isError: true))
      }
    }
  }

  private func calculateHasNext(with totalCount: Int,
                                currentPage: Int) -> Bool {
    let totalPageCount = Int((Double(totalCount) / Double(Constants.pageSize)).rounded(.up)) - 1
    let hasNext = (totalPageCount - currentPage) > 0
    return hasNext
  }
}
