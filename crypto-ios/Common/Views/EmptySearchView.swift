//
//  EmptySearchView.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

final class EmptySearchView: UIView {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("Sorry", comment: "")
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.textColor = UIColor.Text.darkGrey
    label.textAlignment = .center
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("No result match this keyword", comment: "")
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = UIColor.Text.lightGrey
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
    backgroundColor = UIColor.Background.white
    addSubview(titleLabel)
    addSubview(subtitleLabel)

    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(snp.left).offset(16)
      make.right.equalTo(snp.right).offset(-16)
      make.bottom.equalTo(subtitleLabel.snp.top).offset(-12)
    }
    subtitleLabel.snp.makeConstraints { make in
      make.left.equalTo(snp.left).offset(16)
      make.right.equalTo(snp.right).offset(-16)
      make.centerY.equalTo(snp.centerY).offset(-48)
    }
  }
}

