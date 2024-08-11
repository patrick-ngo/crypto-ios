//
//  CoinListSectionHeaderView.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

enum CoinListSectionHeaderMode {
  case top3
  case list
}

final class CoinListSectionHeaderView: UIView {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
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
    backgroundColor = UIColor.Background.white
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(snp.left).offset(16)
      make.right.equalTo(snp.right).offset(-16)
      make.top.equalTo(snp.top).offset(16)
      make.bottom.equalTo(snp.bottom).offset(-8)
    }
  }

  func configure(with mode: CoinListSectionHeaderMode) {
    switch mode {
    case .list:
      titleLabel.text = NSLocalizedString("Buy, sell and hold crypto", comment: "")

    case .top3:
      let fullText = NSLocalizedString("Top 3 rank crypto", comment: "")
      let attributedString = NSMutableAttributedString(string: fullText)

      let fullRange = NSRange(location: 0, length: fullText.count)
      attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: fullRange)
      attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)

      let numberRange = (fullText as NSString).range(of: "3")
      attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: numberRange)
      titleLabel.attributedText = attributedString
    }
  }
}

