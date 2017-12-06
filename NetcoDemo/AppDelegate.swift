//
//  AppDelegate.swift
//  NetcoDemo
//
//  Created by Vladimir Burdukov on 06/12/2017.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white

    window.makeKeyAndVisible()
    self.window = window

    return true
  }

}
