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
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = root()
    window?.makeKeyAndVisible()
    
    return true
  }

}

