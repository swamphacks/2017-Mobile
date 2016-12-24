//
//  AppDelegate.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let happeningNowVC: HappeningNowViewController = controllerFromNib()
    
    
    //******************************************
    
    let announcementLoader = { (completionHandler: (([Announcement]) -> ())) in
      // load announcements from database...
      let announcements = [Announcement(title: "Title", description: "Description", date: Date())]
      completionHandler(announcements)
    }
    
    let announcementSelected = { (announcement: Announcement) in
      // show next VC...
    }
    
    let announcementsVC = ModelTableViewController(load: announcementLoader,
                                                   descriptor: { $0.cellDescriptor },
                                                   didSelect: announcementSelected)
    
    //******************************************
    
    let tabController = UITabBarController()
    tabController.viewControllers = [announcementsVC, happeningNowVC]
    
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()
    
    return true
  }

}

