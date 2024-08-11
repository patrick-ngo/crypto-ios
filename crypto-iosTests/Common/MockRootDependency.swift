//
//  MockRootDependency.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Foundation
@testable import crypto_ios

final class MockRootDependency: RootDependency {
  var coinsApiService: CoinsApiService = MockCoinsApiService()
}
