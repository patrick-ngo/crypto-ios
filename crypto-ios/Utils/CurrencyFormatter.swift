//
//  CurrencyFormatter.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation

struct CurrencyFormatter {

  private static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "$"
    formatter.minimumFractionDigits = 5
    formatter.maximumFractionDigits = 5
    formatter.usesGroupingSeparator = true
    formatter.locale = Locale(identifier: "en_US")
    return formatter
  }()

  private static let priceShortFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "$ "
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = true
    formatter.locale = Locale(identifier: "en_US")
    return formatter
  }()

  private static let marketCapFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()

  static func getDisplayedPrice(for price: String?) -> String {
    guard let price,
          let priceDouble = Double(price),
          let displayedPrice = priceFormatter.string(from: NSNumber(value: priceDouble)) else { return  "" }
    return displayedPrice
  }

  static func getDisplayedShortPrice(for price: String?) -> String {
    guard let price,
          let priceDouble = Double(price),
          let displayedPrice = priceShortFormatter.string(from: NSNumber(value: priceDouble)) else { return  "" }
    return displayedPrice
  }

  static func getDisplayedMarketCap(marketCap: String?) -> String {
    guard let marketCap,
          let marketCapValue = Double(marketCap) else { return "" }

    let trillion = 1_000_000_000_000.0
    let billion = 1_000_000_000.0
    let million = 1_000_000.0
    let currencySymbol = "$ "

    var formattedNumber: String
    if marketCapValue >= trillion {
      let value = marketCapValue / trillion
      formattedNumber = "\(currencySymbol) \(marketCapFormatter.string(from: NSNumber(value: value)) ?? "0.00") trillion"
    } else if marketCapValue >= billion {
      let value = marketCapValue / billion
      formattedNumber = "\(currencySymbol) \(marketCapFormatter.string(from: NSNumber(value: value)) ?? "0.00") billion"
    } else if marketCapValue >= million {
      let value = marketCapValue / million
      formattedNumber = "\(currencySymbol)  \(marketCapFormatter.string(from: NSNumber(value: value)) ?? "0.00") million"
    } else {
      formattedNumber = marketCapFormatter.string(from: NSNumber(value: marketCapValue)) ?? "0.00"
    }
    return formattedNumber
  }
}
