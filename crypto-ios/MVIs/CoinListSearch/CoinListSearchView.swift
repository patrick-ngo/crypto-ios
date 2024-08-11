//
//  CoinListSearchViewController.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

protocol CoinListSearchViewControllerInput: View where AssociatedState == CoinListSearchState {}

final class CoinListSearchView: UIView,
                                UITableViewDelegate,
                                UITableViewDataSource,
                                CoinListSearchViewControllerInput,
                                UISearchBarDelegate {

  var intent: CoinListSearchIntentInput?
  private var currentState: CoinListSearchState = .initialState

  // MARK: - Views

  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = UIColor.Background.white
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = UIColor.Border.around
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CoinListCell.self, forCellReuseIdentifier: String(describing: CoinListCell.self))
    tableView.register(LoadingCell.self, forCellReuseIdentifier: String(describing: LoadingCell.self))
    tableView.register(ErrorCell.self, forCellReuseIdentifier: String(describing: ErrorCell.self))
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 82
    return tableView
  }()

  private let emptySearchView: UIView = {
    let view = EmptySearchView()
    return view
  }()

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(onRefreshPulled), for: .valueChanged)
    refreshControl.tintColor = UIColor.Text.blue
    return refreshControl
  }()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    backgroundColor = UIColor.Background.white
    addSubview(tableView)
    addSubview(emptySearchView)
    tableView.refreshControl = refreshControl

    tableView.snp.makeConstraints { make in
      make.left.right.bottom.top.equalTo(0)
    }
    emptySearchView.snp.makeConstraints { make in
      make.edges.equalTo(tableView.snp.edges)
    }
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    intent?.bind(to: self)
  }

  // MARK: - Update from State

  func update(with state: CoinListSearchState, prevState: CoinListSearchState?) {
    currentState = state

    if !state.isLoading,
       refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }

    if state.coinViewModels != prevState?.coinViewModels
        || state.isError != prevState?.isError  {
      tableView.reloadData()
    }

    if state.isEmptySearchResult != prevState?.isEmptySearchResult {
      emptySearchView.isHidden = !state.isEmptySearchResult
    }
  }

  // MARK: - Interactions

  @objc func onRefreshPulled() {
    intent?.getCoins()
  }

  func onRetryButtonTapped() {
    intent?.getCoins()
  }

  func onEndOfListReached() {
    intent?.getMoreCoins()
  }

  func onCoinCellTapped(with index: Int) {
    intent?.goToCoinDetail(with: index)
  }

  // MARK: - TableViewDelegate

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = CoinListSectionHeaderView()
    headerView.configure(with: .list)
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if currentState.isLoading {
      return 0
    }
    return 50
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if currentState.hasNext {
      return currentState.coinViewModels.count + 1
    }
    return currentState.coinViewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if currentState.hasNext,
       !currentState.isLoading,
       indexPath.row >= currentState.coinViewModels.count - 1 {
      onEndOfListReached()
    }

    if (currentState.hasNext && indexPath.row >= currentState.coinViewModels.count) {
      if currentState.isError {
        let errorCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ErrorCell.self), for: indexPath)
        (errorCell as? ErrorCell)?.onRetryTapped = { [weak self] in
          self?.onRetryButtonTapped()
        }
        return errorCell
      } else {
        let loadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath)
        return loadingCell
      }
    }

    let coinCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinListCell.self), for: indexPath)
    if let coinListCell = coinCell as? CoinListCell {
      let viewModel = currentState.coinViewModels[indexPath.row]
      coinListCell.update(with: viewModel)
    }
    return coinCell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onCoinCellTapped(with: indexPath.row)
  }
}

