//
//  CoinListInviteFriendCell.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 11/8/24.
//

import UIKit

final class CoinListInviteFriendCell: UITableViewCell,
                                      UITextViewDelegate {

  var onLinkTapped: (() -> Void)?

  // MARK: - Views

  private let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.Background.blue
    view.layer.cornerRadius = 8.0
    return view
  }()

  private let logoContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Background.grey
    view.layer.cornerRadius = 20
    return view
  }()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "gift")
    return imageView
  }()

  private lazy var descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    textView.textColor = UIColor.Text.darkGrey
    textView.textAlignment = .left
    textView.backgroundColor = .clear
    textView.isEditable = false
    textView.isSelectable = true
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0
    textView.delegate = self
    return textView
  }()

  //MARK: - Init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style:style, reuseIdentifier:reuseIdentifier)
    setupViews()
    setupText()
  }

  func setupViews() {
    selectionStyle = .none
    contentView.backgroundColor = UIColor.Background.white
    contentView.addSubview(containerView)
    containerView.addSubview(logoContainerView)
    logoContainerView.addSubview(logoImageView)
    containerView.addSubview(descriptionTextView)

    containerView.snp.makeConstraints { make in
      make.left.equalTo(contentView.snp.left).offset(8)
      make.right.equalTo(contentView.snp.right).offset(-8)
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom).offset(-12)
    }
    logoContainerView.snp.makeConstraints { make in
      make.left.equalTo(containerView.snp.left).offset(16)
      make.width.height.equalTo(40)
      make.top.equalTo(20)
      make.bottom.equalTo(0).offset(-20)
    }
    logoImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.width.equalTo(22)
    }
    descriptionTextView.snp.makeConstraints { make in
      make.left.equalTo(logoImageView.snp.right).offset(16)
      make.right.equalTo(snp.right).offset(-16)
      make.centerY.equalTo(logoContainerView.snp.centerY).offset(4)
      make.height.equalTo(48)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupText() {
    let fullText = NSLocalizedString("You can earn $10 when you invite a friend to buy crypto. Invite your friend", comment: "")
    let inviteText = NSLocalizedString("Invite your friend", comment: "")

    let attributedString = NSMutableAttributedString(string: fullText)

    let fullRange = NSRange(location: 0, length: fullText.count)
    attributedString.addAttribute(.foregroundColor, value: UIColor.Text.darkGrey, range: fullRange)
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: fullRange)

    if let inviteRange = fullText.range(of: inviteText) {
      let clickableRange = NSRange(inviteRange, in: fullText)
      attributedString.addAttribute(.foregroundColor, value: UIColor.Text.blue, range: clickableRange)
      attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: clickableRange)
      attributedString.addAttribute(.link, value: "", range: clickableRange)
    }

    descriptionTextView.attributedText = attributedString
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    onLinkTapped?()
    return false
  }
}
