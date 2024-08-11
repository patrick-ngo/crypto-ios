//
//  ErrorCell.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell {

  var onRetryTapped: (() -> Void)?

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textColor = UIColor.Text.darkGrey
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = NSLocalizedString("Could not load data", comment: "")
    return label
  }()

  private lazy var retryButton: UIButton = {
    let button = UIButton()
    button.setTitle("Try again", for: .normal)
    button.setTitleColor(UIColor.Text.blue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    button.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)
    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupViews()
  }

  private func setupViews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(retryButton)

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.top).offset(20)
      make.left.equalTo(contentView.snp.left)
      make.right.equalTo(contentView.snp.right)
    }
    retryButton.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.bottom.equalTo(contentView.snp.bottom).offset(-20)
      make.left.equalTo(contentView.snp.left)
      make.right.equalTo(contentView.snp.right)
    }
  }

  @objc private func onRetryButtonTapped() {
    onRetryTapped?()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
