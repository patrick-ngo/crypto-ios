//
//  LoadingCell.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

final class LoadingCell: UITableViewCell {
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator =  UIActivityIndicatorView(style: .medium)
    activityIndicator.tintColor = UIColor.Text.blue
    return activityIndicator
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    contentView.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.center.equalTo(contentView)
    }
    activityIndicator.startAnimating()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicator.startAnimating()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
