//
//  CoinListTopRankingRowCell.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

final class CoinListTopRankingRowCell: UITableViewCell,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {

  var onCellTapped: ((Int) -> Void)?

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = UIColor.Background.white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CoinListTopRankingCollectionCell.self, forCellWithReuseIdentifier: String(describing: CoinListTopRankingCollectionCell.self))
    collectionView.clipsToBounds = false
    return collectionView
  }()

  private var coinViewModels: [CoinListCellViewModel] = []

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style:style, reuseIdentifier:reuseIdentifier)
    self.setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    contentView.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(140)
    }
  }

  func configure(with coinViewModels: [CoinListCellViewModel]) {
    self.coinViewModels = coinViewModels
    collectionView.reloadData()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return coinViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CoinListTopRankingCollectionCell.self), for: indexPath) as? CoinListTopRankingCollectionCell {
      let coinViewModel = coinViewModels[indexPath.item]
      cell.configure(with: coinViewModel)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let totalHorizontalPadding: CGFloat = 16 * 2
    let totalSpacingBetweenCells: CGFloat = 16 * 2
    let availableWidth = contentView.bounds.width - totalHorizontalPadding - totalSpacingBetweenCells
    let width = availableWidth / 3
    return CGSize(width: width, height: 140)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    onCellTapped?(indexPath.item)
  }
}


fileprivate class CoinListTopRankingCollectionCell: UICollectionViewCell {

  private let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.Background.grey
    view.layer.shadowColor = UIColor.black.withAlphaComponent(0.10).cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 1.0
    view.layer.shadowRadius = 2.0
    view.layer.cornerRadius = 8.0
    return view
  }()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let symbolLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textAlignment = .center
    label.textColor = UIColor.Text.darkGrey
    return label
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textAlignment = .center
    label.textColor = UIColor.Text.lightGrey
    return label
  }()

  private let priceChangeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    contentView.addSubview(containerView)
    containerView.addSubview(logoImageView)
    containerView.addSubview(symbolLabel)
    containerView.addSubview(nameLabel)
    containerView.addSubview(priceChangeLabel)

    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    logoImageView.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.top).offset(16)
      make.centerX.equalTo(containerView.snp.centerX)
      make.width.height.equalTo(40)
    }
    symbolLabel.snp.makeConstraints { make in
      make.top.equalTo(logoImageView.snp.bottom).offset(8)
      make.left.equalTo(containerView.snp.left).offset(8)
      make.right.equalTo(containerView.snp.right).offset(-8)
    }
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(symbolLabel.snp.bottom).offset(8)
      make.left.equalTo(containerView.snp.left).offset(8)
      make.right.equalTo(containerView.snp.right).offset(-8)
    }
    priceChangeLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(8)
      make.left.equalTo(containerView.snp.left).offset(8)
      make.right.equalTo(containerView.snp.right).offset(-8)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    logoImageView.sd_cancelCurrentImageLoad()
  }

  func configure(with viewModel: CoinListCellViewModel) {
    nameLabel.text = viewModel.title
    symbolLabel.text = viewModel.symbol
    priceChangeLabel.text = viewModel.change
    priceChangeLabel.textColor = viewModel.changeColor
    logoImageView.loadImage(with: viewModel.logoUrl)
  }
}
