//
//  CoinListCell.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

enum CoinListCellType {
  case coin
  case inviteFriend
}

struct CoinListCellViewModel: Equatable {
  let type: CoinListCellType
  let id: String?
  let title: String?
  let symbol: String?
  let logoUrl: String?
  let price: String?
  let change: String?
  let changeColor: UIColor?
}

final class CoinListCell: UITableViewCell {

  // MARK: - Views

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
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.textAlignment = .left
    return label
  }()

  private let symbolLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textColor = UIColor.Text.lightGrey
    label.textAlignment = .left
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.textAlignment = .right
    return label
  }()

  private let changeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textColor = UIColor.Text.green
    label.textAlignment = .right
    return label
  }()

  //MARK: - Init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style:style, reuseIdentifier:reuseIdentifier)
    self.setupViews()
  }

  func setupViews() {
    selectionStyle = .none
    contentView.backgroundColor = UIColor.Background.white
    contentView.addSubview(containerView)
    containerView.addSubview(logoImageView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(symbolLabel)
    containerView.addSubview(priceLabel)
    containerView.addSubview(changeLabel)

    containerView.snp.makeConstraints { make in
      make.left.equalTo(contentView.snp.left).offset(8)
      make.right.equalTo(contentView.snp.right).offset(-8)
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom).offset(-12)
    }
    logoImageView.snp.makeConstraints { make in
      make.left.equalTo(containerView.snp.left).offset(16)
      make.width.height.equalTo(40)
      make.top.equalTo(20)
      make.bottom.equalTo(0).offset(-20)
    }
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(logoImageView.snp.right).offset(10)
      make.right.equalTo(priceLabel.snp.left).offset(-4)
      make.top.equalTo(20)
    }
    symbolLabel.snp.makeConstraints { make in
      make.left.equalTo(logoImageView.snp.right).offset(10)
      make.right.equalTo(containerView)
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
    }
    priceLabel.snp.makeConstraints { make in
      make.right.equalTo(containerView).offset(-16)
      make.centerY.equalTo(titleLabel.snp.centerY)
    }
    changeLabel.snp.makeConstraints { make in
      make.right.equalTo(containerView).offset(-16)
      make.centerY.equalTo(symbolLabel.snp.centerY)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Update

  func update(with viewModel: CoinListCellViewModel) {
    titleLabel.text = viewModel.title
    symbolLabel.text = viewModel.symbol
    priceLabel.text = viewModel.price
    changeLabel.text = viewModel.change
    changeLabel.textColor = viewModel.changeColor
    logoImageView.loadImage(with: viewModel.logoUrl)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    logoImageView.sd_cancelCurrentImageLoad()
    logoImageView.image = nil
  }
}
