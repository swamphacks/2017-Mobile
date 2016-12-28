//
//  AppDelegate.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FIRApp.configure()
    setUpUI()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = root()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  fileprivate func setUpUI() {
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().barTintColor = UIColor.turquoise
    UINavigationBar.appearance().shadowImage = nil
    UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }

}

