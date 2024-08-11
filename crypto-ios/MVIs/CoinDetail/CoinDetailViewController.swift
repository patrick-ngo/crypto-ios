//
//  CoinDetailViewController.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit
import SnapKit

protocol CoinDetailViewControllerInput: View where AssociatedState == CoinDetailState {}


final class CoinDetailViewController: UIViewController,
                                      CoinDetailViewControllerInput {

  // MARK: - Views

  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = UIColor.Text.darkGrey
    button.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
    return button
  }()

  private let scrollView: UIScrollView = {
    let view = UIScrollView()
    view.backgroundColor = UIColor.Background.white
    view.alwaysBounceVertical = true
    return view
  }()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.numberOfLines = 0
    return label
  }()

  private let symbolLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = UIColor.Text.darkGrey
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.text = NSLocalizedString("PRICE", comment: "")
    return label
  }()

  private let priceValueLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textColor = UIColor.Text.darkGrey
    return label
  }()

  private let marketCapLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.text = NSLocalizedString("MARKET CAP", comment: "")
    return label
  }()

  private let marketCapValueLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textColor = UIColor.Text.darkGrey
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.textColor = UIColor.Text.lightGrey
    label.numberOfLines = 0
    return label
  }()

  private let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Border.around
    return view
  }()

  private lazy var websiteButton: UIButton = {
    let button = UIButton()
    button.setTitle(NSLocalizedString("GO TO WEBSITE", comment: ""), for: .normal)
    button.setTitleColor(UIColor.Text.blue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    button.addTarget(self, action: #selector(onWebsiteButtonTapped), for: .touchUpInside)
    return button
  }()

  //MARK: - Init

  var intent: CoinDetailIntentInput?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()

    intent?.bind(to: self)
    intent?.getCoin()
  }

  private func setupViews() {
    view.backgroundColor = UIColor.Background.white
    view.addSubview(scrollView)
    view.addSubview(closeButton)
    view.addSubview(separatorView)
    view.addSubview(websiteButton)
    scrollView.addSubview(logoImageView)
    scrollView.addSubview(nameLabel)
    scrollView.addSubview(symbolLabel)
    scrollView.addSubview(priceLabel)
    scrollView.addSubview(priceValueLabel)
    scrollView.addSubview(marketCapLabel)
    scrollView.addSubview(marketCapValueLabel)
    scrollView.addSubview(descriptionLabel)

    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalTo(24)
      make.right.equalTo(-24)
      make.bottom.equalTo(websiteButton.snp.top)
    }
    closeButton.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top).offset(16)
      make.right.equalTo(view.snp.right).offset(-16)
    }
    logoImageView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.snp.top).offset(32)
      make.left.equalTo(scrollView.snp.left)
      make.height.width.equalTo(50)
    }
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(logoImageView.snp.top)
      make.left.equalTo(logoImageView.snp.right).offset(16)
    }
    symbolLabel.snp.makeConstraints { make in
      make.bottom.equalTo(nameLabel.snp.bottom).offset(-2)
      make.left.equalTo(nameLabel.snp.right).offset(2)
    }
    priceLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(6)
      make.left.equalTo(nameLabel.snp.left)
    }
    priceValueLabel.snp.makeConstraints { make in
      make.centerY.equalTo(priceLabel.snp.centerY)
      make.left.equalTo(priceLabel.snp.right).offset(8)
    }
    marketCapLabel.snp.makeConstraints { make in
      make.top.equalTo(priceLabel.snp.bottom).offset(6)
      make.left.equalTo(nameLabel.snp.left)
    }
    marketCapValueLabel.snp.makeConstraints { make in
      make.centerY.equalTo(marketCapLabel.snp.centerY)
      make.left.equalTo(marketCapLabel.snp.right).offset(8)
    }
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(marketCapLabel.snp.bottom).offset(16)
      make.left.equalTo(view.snp.left).offset(24)
      make.right.equalTo(view.snp.right).offset(-24)
    }
    separatorView.snp.makeConstraints { make in
      make.left.equalTo(0)
      make.right.equalTo(0)
      make.top.equalTo(websiteButton.snp.top)
      make.height.equalTo(1)
    }
    websiteButton.snp.makeConstraints { make in
      make.left.equalTo(0)
      make.right.equalTo(0)
      make.height.equalTo(48)
      make.top.equalTo(scrollView.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  func update(with state: CoinDetailState, prevState: CoinDetailState?) {
    nameLabel.text = state.name
    nameLabel.textColor = state.nameColor
    symbolLabel.text = "(\(state.symbol))"
    priceValueLabel.text = state.price
    marketCapValueLabel.text = state.marketCap
    descriptionLabel.text = state.description
    logoImageView.loadImage(with: state.logoUrl)
  }


  @objc func onBackButtonTapped() {
    intent?.goBack()
  }

  @objc func onWebsiteButtonTapped() {
    intent?.goToWebsite()
  }
}
