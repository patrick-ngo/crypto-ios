//
//  RootDependency.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation

protocol RootDependency {
  var coinsApiService: CoinsApiService { get }
}

final class RootDependencyImp: RootDependency {
  let coinsApiService: CoinsApiService

  public init(coinsApiService: CoinsApiService) {
    self.coinsApiService = coinsApiService
  }
}
