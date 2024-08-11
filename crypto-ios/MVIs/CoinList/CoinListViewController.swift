//
//  CoinListViewController.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
import SnapKit

protocol CoinListViewControllerInput: View where AssociatedState == CoinListState {}

final class CoinListViewController: UIViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource,
                                    CoinListViewControllerInput,
                                    UISearchBarDelegate,
                                    SearchInputDelegate {
  var intent: CoinListIntentInput?
  private var currentState: CoinListState = .initialState

  // MARK: - Views

  private lazy var searchContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Background.white
    view.isHidden = true
    return view
  }()

  private lazy var searchInput: SearchInput = {
    let searchInput = SearchInput()
    searchInput.placeholder = NSLocalizedString("Search", comment: "")
    searchInput.delegate = self
    return searchInput
  }()

  private let searchLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Background.searchGrey
    return view
  }()

  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = UIColor.Background.white
    tableView.separatorStyle = .none
    tableView.separatorColor = UIColor.Border.around
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CoinListTopRankingRowCell.self, forCellReuseIdentifier: String(describing: CoinListTopRankingRowCell.self))
    tableView.register(CoinListCell.self, forCellReuseIdentifier: String(describing: CoinListCell.self))
    tableView.register(CoinListInviteFriendCell.self, forCellReuseIdentifier: String(describing: CoinListInviteFriendCell.self))
    tableView.register(LoadingCell.self, forCellReuseIdentifier: String(describing: LoadingCell.self))
    tableView.register(ErrorCell.self, forCellReuseIdentifier: String(describing: ErrorCell.self))
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 82
    return tableView
  }()

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(onRefreshPulled), for: .valueChanged)
    refreshControl.tintColor = UIColor.Text.blue
    return refreshControl
  }()

  // MARK: - Init

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    setupViews()

    intent?.bind(to: self)
    intent?.getCoins()
  }

  private func setupNavBar() {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  private func setupViews() {
    view.backgroundColor = UIColor.Background.white
    view.addSubview(searchInput)
    view.addSubview(tableView)
    view.addSubview(searchLineView)
    view.addSubview(searchContainerView)
    tableView.refreshControl = refreshControl

    searchInput.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
      make.left.equalTo(view.snp.left).offset(16)
      make.right.equalTo(view.snp.right).offset(-16)
      make.height.equalTo(48)
    }
    searchLineView.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      make.height.equalTo(1)
      make.top.equalTo(searchInput.snp.bottom).offset(16)
    }
    tableView.snp.makeConstraints { make in
      make.left.right.bottom.equalTo(0)
      make.top.equalTo(searchInput.snp.bottom).offset(16)
      make.bottom.equalToSuperview()
    }
    searchContainerView.snp.makeConstraints { make in
      make.edges.equalTo(tableView)
    }
  }

  // MARK: - Update from State

  func update(with state: CoinListState, prevState: CoinListState?) {
    currentState = state

    if !state.isLoading,
       refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }

    if state.coinViewModels != prevState?.coinViewModels
        || state.isError != prevState?.isError  {
      tableView.reloadData()
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

  func onTopCoinCellTapped(with index: Int) {
    intent?.goToTopCoinDetail(with: index)
  }

  func onCoinCellTapped(with index: Int) {
    intent?.goToCoinDetail(with: index)
  }

  func onInviteFriendTapped() {
    intent?.attachShareSheet()
  }

  func onSearchTextChanged(with searchText: String) {
    intent?.updateSearch(with: searchText, containerView: searchContainerView)
  }

  // MARK: - TableViewDelegate

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = CoinListSectionHeaderView()
    switch section {
    case 0:
      headerView.configure(with: .top3)
    case 1:
      headerView.configure(with: .list)
    default:
      break
    }
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if currentState.isLoading {
      return 0
    }
    return 50
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      if currentState.hasNext || currentState.isInitialLoading {
        return currentState.coinViewModels.count + 1
      }
      return currentState.coinViewModels.count
    default:
      return 0
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let topCoinCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinListTopRankingRowCell.self), for: indexPath)
      if let topCoinCell = topCoinCell as? CoinListTopRankingRowCell {
        let viewModels = currentState.topCoinViewModels
        topCoinCell.configure(with: viewModels)
        topCoinCell.onCellTapped = { [weak self] row in
          self?.onTopCoinCellTapped(with: row)
        }
      }
      return topCoinCell
    default:
      if currentState.hasNext,
         !currentState.isLoading,
         indexPath.row >= currentState.coinViewModels.count - 1 {
        onEndOfListReached()
      }

      if (currentState.hasNext && indexPath.row >= currentState.coinViewModels.count) || currentState.isInitialLoading {
        if currentState.isError {
          let errorCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ErrorCell.self), for: indexPath)
          if let errorCell = errorCell as? ErrorCell {
            errorCell.onRetryTapped = { [weak self] in
              self?.onRetryButtonTapped()
            }
          }
          return errorCell
        } else {
          let loadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath)
          return loadingCell
        }
      }

      let viewModel = currentState.coinViewModels[indexPath.row]
      switch viewModel.type {
      case .coin:
        let coinListCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinListCell.self), for: indexPath)
        if let coinListCell = coinListCell as? CoinListCell {
          let viewModel = currentState.coinViewModels[indexPath.row]
          coinListCell.update(with: viewModel)
        }
        return coinListCell
      case .inviteFriend:
        let inviteFriendCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinListInviteFriendCell.self), for: indexPath)
        if let inviteFriendCell = inviteFriendCell as? CoinListInviteFriendCell{
          inviteFriendCell.onLinkTapped = { [weak self] in
            self?.onInviteFriendTapped()
          }
        }
        return inviteFriendCell
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      break
    default:
      onCoinCellTapped(with: indexPath.row)
    }
  }

  // MARK: - SearchInputDelegate

  func searchInput(_ searchInput: SearchInput, willChangeText text: String) {
    onSearchTextChanged(with: text)
  }
}

