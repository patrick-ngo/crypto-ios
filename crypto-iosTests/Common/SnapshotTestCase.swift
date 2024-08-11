//
//  SnapshotTestCase.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import FBSnapshotTestCase

class SnapshotTestCase: FBSnapshotTestCase {

  private enum Constants {
    static let recordingEnvVariable = "IS_RECORDING_SNAPSHOTS"
    static let overallTolerance: CGFloat = 0.0006
    static let perPixelTolerance: CGFloat = 0.06
  }

  override open func setUp() {
    super.setUp()
    recordMode = ProcessInfo.processInfo.environment[Constants.recordingEnvVariable] == "true"
  }

  func verifyViewWithTolerance(_ view: UIView,
                               identifier: String? = nil,
                               file: StaticString = #file,
                               line: UInt = #line) {
    view.layoutIfNeeded()
    FBSnapshotVerifyView(view, identifier: identifier,
                         perPixelTolerance: Constants.perPixelTolerance,
                         overallTolerance: Constants.overallTolerance,
                         file: file,
                         line: line)
  }

  func verifyViewControllerWithTolerance(_ viewController: UIViewController,
                                         identifier: String? = nil,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
    viewController.view.layoutIfNeeded()
    FBSnapshotVerifyViewController(viewController,
                                   identifier: identifier,
                                   perPixelTolerance: Constants.perPixelTolerance,
                                   overallTolerance: Constants.overallTolerance,
                                   file: file,
                                   line: line)
  }
}
