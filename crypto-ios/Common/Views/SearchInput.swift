//
//  SearchInput.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import UIKit

protocol SearchInputDelegate: AnyObject {
  func searchInput(_ searchInput: SearchInput, willChangeText text: String)
}

final class SearchInput: UIView, UITextFieldDelegate {

  weak var delegate: SearchInputDelegate?

  var text: String? {
    didSet {
      guard text != inputField.text else { return }
      inputField.text = text
    }
  }

  var placeholder: String? {
    didSet {
      inputField.attributedPlaceholder = NSAttributedString(
          string: placeholder ?? "",
          attributes: [NSAttributedString.Key.foregroundColor: UIColor.Text.darkGrey]
      )
    }
  }

  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Background.searchGrey
    view.layer.cornerRadius = 8
    return view
  }()

  private let searchIconView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "magnifyingglass")
    imageView.tintColor = UIColor.Text.placeholderGrey
    return imageView
  }()

  lazy var inputField: UITextField = {
    let input = UITextField()
    input.textColor = UIColor.Text.darkGrey
    input.tintColor = UIColor.Text.darkGrey
    input.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    input.clearButtonMode = .whileEditing
    input.delegate = self
    return input
  }()

  init() {
    super.init(frame: .zero)
    setupViews()
    inputField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
    inputField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingDidEnd)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    backgroundColor = .clear

    addSubview(contentView)
    contentView.addSubview(searchIconView)
    contentView.addSubview(inputField)

    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    searchIconView.snp.makeConstraints { make in
      make.height.width.equalTo(18)
      make.centerY.equalToSuperview()
      make.left.equalTo(contentView).offset(12)
    }

    inputField.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(12)
      make.left.equalTo(searchIconView.snp.right).offset(12)
      make.trailing.equalToSuperview().inset(12)
    }
  }

  override func becomeFirstResponder() -> Bool {
    inputField.becomeFirstResponder()
  }


  @objc func onTextFieldDidChange() {
    guard let text = inputField.text else { return }
    delegate?.searchInput(self, willChangeText: text)

    if text.isEmpty {
      DispatchQueue.main.async { [weak self] in
        self?.inputField.resignFirstResponder()
      }
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
