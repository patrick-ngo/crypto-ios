//
//  RxUtils.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import RxSwift
import RxCocoa

/// BehaviorRelay is wrapped in ReadOnly and Mutable classes.
class ReadonlyBehaviorRelay<Element>: ObservableType {

  fileprivate let relay: BehaviorRelay<Element>

  /// Current value of behavior relay
  var value: Element {
    return relay.value
  }

  /// Initializes variable with initial value.
  init(value: Element) {
    relay = BehaviorRelay(value: value)
  }

  /// Subscribes observer
  func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
    return relay.subscribe(observer)
  }

  /// - returns: Canonical interface for push style sequence
  func asObservable() -> Observable<Element> {
    return relay.asObservable()
  }
}

final class MutableBehaviorRelay<Element>: ReadonlyBehaviorRelay<Element> {
  // Accepts `event` and emits it to subscribers
  func accept(_ event: Element) {
    relay.accept(event)
  }
}


/// PublishRelay is wrapped in ReadOnly and Mutable classes.
class ReadonlyPublishRelay<Element>: ObservableType {

  fileprivate let relay: PublishRelay<Element>

  /// Initializes variable with initial value.
  init() {
    relay = PublishRelay()
  }

  /// Subscribes observer
  func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
    return relay.subscribe(observer)
  }

  /// - returns: Canonical interface for push style sequence
  func asObservable() -> Observable<Element> {
    return relay.asObservable()
  }
}

class MutablePublishRelay<Element>: ReadonlyPublishRelay<Element> {
  // Accepts `event` and emits it to subscribers
  func accept(_ event: Element) {
    relay.accept(event)
  }
}

extension ObservableType {
  func withPrevious() -> Observable<(Element?, Element)> {
    return scan([], accumulator: { (previous, current) in
      Array(previous + [current]).suffix(2)
    })
    .map({ (arr) -> (previous: Element?, current: Element) in
      (arr.count > 1 ? arr.first : nil, arr.last!)
    })
  }
}
