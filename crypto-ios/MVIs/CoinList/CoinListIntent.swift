//
//  CoinListIntent.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

protocol CoinListListener: AnyObject {}

protocol CoinListIntentInput {
  func bind<V: CoinListViewControllerInput>(to view: V)
  func getCoins()
  func getMoreCoins()
  func goToCoinDetail(with index: Int)
  func goToTopCoinDetail(with index: Int)
  func updateSearch(with searchText: String, containerView: UIView)
  func attachShareSheet()
}

final class CoinListIntent: CoinListIntentInput {

  private enum Constants {
    static let firstPage = 0
    static let pageSize = 30
    static let numberOfTopRanking = 3
  }

  weak var coordinator: CoinListCoordinatorInput?
  private weak var listener: CoinListListener?
  private let coinsApiService: CoinsApiService
  private let searchTextRelay: MutableBehaviorRelay<String>
  private let stateDriver: StateDriver<CoinListState>
  private let disposeBag = DisposeBag()

  private var currentState: CoinListState {
    return stateDriver.value
  }

  init(coinsApiService: CoinsApiService,
       searchTextRelay: MutableBehaviorRelay<String> = MutableBehaviorRelay(value: "")) {
    self.coinsApiService = coinsApiService
    self.searchTextRelay = searchTextRelay
    stateDriver = StateDriver<CoinListState>(value: CoinListState(prevState: CoinListState.initialState))
  }

  func bind<V: CoinListViewControllerInput>(to view: V) {
    stateDriver.bind(to: view)
      .disposed(by: disposeBag)
  }

  func goToCoinDetail(with index: Int) {
    guard currentState.coinViewModels.indices.contains(index) else { return }
    let selectedCoinViewModel = currentState.coinViewModels[index]

    if let id = selectedCoinViewModel.id,
       let selectedCoin = currentState.coinsDict[id] {
      coordinator?.goToCoinDetail(with: selectedCoin)
    }
  }

  func goToTopCoinDetail(with index: Int) {
    guard currentState.topCoinViewModels.indices.contains(index) else { return }
    let selectedCoinViewModel = currentState.topCoinViewModels[index]

    if let id = selectedCoinViewModel.id,
       let selectedCoin = currentState.coinsDict[id] {
      coordinator?.goToCoinDetail(with: selectedCoin)
    }
  }

  func updateSearch(with searchText: String,
                        containerView: UIView) {
    searchTextRelay.accept(searchText)
    if !searchText.isEmpty {
      coordinator?.attachSearchViewIfNeeded(with: searchTextRelay,
                                            containerView: containerView)
    }
  }

  func attachShareSheet() {
    coordinator?.attachShareSheet()
  }

  func getCoins() {
    fetchCoins(for: Constants.firstPage)
  }

  func getMoreCoins() {
    let nextPage = currentState.page + 1
    fetchCoins(for: nextPage)
  }

  private func fetchCoins(for page: Int) {
    stateDriver.accept(CoinListState(prevState: currentState,
                                     page: page,
                                     isLoading: true,
                                     inviteFriendPosition: page == Constants.firstPage ? CoinListState.initialState.inviteFriendPosition : nil))

    coinsApiService.fetchCoinList(for: page,
                                  pageSize: Constants.pageSize,
                                  searchText: nil) { [weak self] coinListResult in
      guard let this = self else { return }
      switch coinListResult {
      case .success(let coinListResponse):
        if let coins = coinListResponse.data.coins,
           let totalCount = coinListResponse.data.stats?.total {
          let hasNext = this.calculateHasNext(with: totalCount, currentPage: page)

          if page == Constants.firstPage {
            let coinsDict = coins.reduce(into: [String: Coin]()) { dict, coin in
              dict[coin.uuid] = coin
            }
            let topCoinViewModels = Array(coins.prefix(Constants.numberOfTopRanking))
              .map { this.getCoinCellViewModel(from: $0) }
            let firstPageCoinViewModels = Array(coins.dropFirst(Constants.numberOfTopRanking))
              .map { this.getCoinCellViewModel(from: $0) }
            let (inviteFriendPosition, coinViewModels) = this.insertInviteFriendIfNecessary(coinViewModels: firstPageCoinViewModels)

            this.stateDriver.accept(CoinListState(prevState: this.currentState,
                                                  hasNext: hasNext,
                                                  isLoading: false,
                                                  isError: false,
                                                  inviteFriendPosition: inviteFriendPosition,
                                                  coinsDict: coinsDict,
                                                  topCoinViewModels: topCoinViewModels,
                                                  coinViewModels: coinViewModels))
          } else {
            let newCoinViewModels = coins.map { this.getCoinCellViewModel(from: $0) }
            let updatedCoinViewModels = this.currentState.coinViewModels + newCoinViewModels
            var coinsDict = this.currentState.coinsDict
            coins.forEach { coin in
              coinsDict[coin.uuid] = coin
            }
            let (inviteFriendPosition, coinViewModels) = this.insertInviteFriendIfNecessary(coinViewModels: updatedCoinViewModels)

            this.stateDriver.accept(CoinListState(prevState: this.currentState,
                                                  hasNext: hasNext,
                                                  isLoading: false,
                                                  isError: false,
                                                  inviteFriendPosition: inviteFriendPosition,
                                                  coinsDict: coinsDict,
                                                  coinViewModels: coinViewModels))
          }
        }
      case .failure:
        this.stateDriver.accept(CoinListState(prevState: this.currentState,
                                              isLoading: false,
                                              isError: true))
      }
    }
  }

  private func getCoinCellViewModel(from coin: Coin) -> CoinListCellViewModel {
    let displayedPrice = CurrencyFormatter.getDisplayedPrice(for: coin.price)
    let displayedChange = PriceChangeFormatter.getDisplayedchange(for: coin.change)
    return CoinListCellViewModel(type: .coin,
                                 id: coin.uuid,
                                 title: coin.name,
                                 symbol: coin.symbol,
                                 logoUrl: coin.iconUrl,
                                 price: displayedPrice,
                                 change: displayedChange.change,
                                 changeColor: displayedChange.color)
  }

  private func insertInviteFriendIfNecessary(coinViewModels: [CoinListCellViewModel]) -> (inviteFriendPosition: Int, coinViewModels: [CoinListCellViewModel]) {
    var updatedCoinViewModels = coinViewModels
    var updatedInviteFriendPosition = currentState.inviteFriendPosition
    var targetIndex = updatedInviteFriendPosition - 1

    while coinViewModels.indices.contains(targetIndex) {
      updatedCoinViewModels.insert(getInviteFriendCellViewModel(), at: targetIndex)
      updatedInviteFriendPosition = updatedInviteFriendPosition * 2
      targetIndex = updatedInviteFriendPosition - 1
    }
    return (updatedInviteFriendPosition, updatedCoinViewModels)
  }

  private func getInviteFriendCellViewModel() -> CoinListCellViewModel {
    return CoinListCellViewModel(type: .inviteFriend,
                                 id: nil,
                                 title: nil,
                                 symbol: nil,
                                 logoUrl: nil,
                                 price: nil,
                                 change: nil,
                                 changeColor: nil)
  }

  private func calculateHasNext(with totalCount: Int,
                                currentPage: Int) -> Bool {
    let totalPageCount = Int((Double(totalCount) / Double(Constants.pageSize)).rounded(.up)) - 1
    let hasNext = (totalPageCount - currentPage) > 0
    return hasNext
  }
}
