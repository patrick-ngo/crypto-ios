//
//  AppDelegate.swift
//  crypto-ios
//
//  Created by Patrick Hung Son Ngo on 11/8/24.
//

import UIKit
import SDWebImageSVGKitPlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var rootCoordinator: RootCoordinator?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    if #available(iOS 13.0, *) {
        // window is set up in SceneDelegate
    } else {
      // Override point for customization after application launch.
      self.window = UIWindow(frame: UIScreen.main.bounds)
      self.window?.makeKeyAndVisible()

      let svgCoder = SDImageSVGKCoder.shared
      SDImageCodersManager.shared.addCoder(svgCoder)

      rootCoordinator = RootCoordinator(keyWindow: self.window!)
      rootCoordinator?.start()
    }

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

