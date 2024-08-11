//
//  MVIUtils.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import RxSwift
import RxCocoa

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  func start()
  func finish()
  func childDidFinish(child: Coordinator)
}

extension Coordinator {
  func childDidFinish(child: Coordinator) {
    for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
      childCoordinators.remove(at: index)
    }
  }
}

protocol View: AnyObject {
  associatedtype AssociatedState: State
  func update(with state: AssociatedState, prevState: AssociatedState?)
}

protocol State {
  static var initialState: Self { get }
}

final class StateDriver<S: State> {

  private let relay: BehaviorRelay<S>

  var value: S {
    return relay.value
  }

  init() {
    relay = BehaviorRelay<S>(value: S.initialState)
  }

  init(value: S) {
    relay = BehaviorRelay<S>(value: value)
  }

  func accept(_ event: S) {
    relay.accept(event)
  }

  func bind<V: View>(to view: V) -> Disposable where V.AssociatedState == S {
    return relay
      .withPrevious()
      .asDriver(onErrorJustReturn: (prevState: nil, state: S.initialState))
      .drive(onNext: { [weak view] prevState, state in
        view?.update(with: state, prevState: prevState)
      })
  }
}
