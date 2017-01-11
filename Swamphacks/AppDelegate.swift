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
  fileprivate(set) var app: App!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FIRApp.configure()
    setUpUI()
    
    try! FIRAuth.auth()?.signOut()
    
    app = App()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = app.root
    window!.makeKeyAndVisible()
    
    addStatusBarView()
    
    return true
  }
  
  fileprivate func setUpUI() {
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().barTintColor = .turquoise
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
  }
  
  fileprivate func addStatusBarView() {
    let statusBarView = UIView(frame: .zero)
    statusBarView.backgroundColor = .turquoise
    
    statusBarView.translatesAutoresizingMaskIntoConstraints = false
    window!.addSubview(statusBarView)
    
    let top = statusBarView.topAnchor.constraint(equalTo: window!.topAnchor)
    let left = statusBarView.leftAnchor.constraint(equalTo: window!.leftAnchor)
    let right = statusBarView.rightAnchor.constraint(equalTo: window!.rightAnchor)
    let height = statusBarView.heightAnchor.constraint(equalToConstant: 20)
    
    NSLayoutConstraint.activate([top, left, right, height])
  }

}

