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
    
    let happeningNowVC = HappeningNowViewController(nibName: String(describing: HappeningNowViewController.self), bundle: nil)
    
    //******************************************
    
    let announcementLoader = { (completionHandler: (([Announcement]) -> ())) in
      // load announcements from database...
      let announcements = [Announcement(title: "Title", description: "Description", dateString: "Sat 9:00am"),
                           Announcement(title: "Hacker Registration", description: "There's a bear!", dateString: "Sat 3:00pm")] 
      
      completionHandler(announcements)
    }
    
    let announcementSelected = { (announcement: Announcement) in
      // show next VC...
    }
    
    let tableDescriptor = TableViewDescriptor(style: .plain, rowHeight: 70)
    
    let announcementsVC = ModelTableViewController(tableDescriptor: tableDescriptor,
                                                   cellDescriptor: { $0.cellDescriptor },
                                                   load: announcementLoader,
                                                   didSelect: announcementSelected)
    
    announcementsVC.tableView.separatorStyle = .none
    announcementsVC.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    
    //******************************************
    
    let tabController = UITabBarController()
    tabController.viewControllers = [announcementsVC.rooted(), happeningNowVC]
    
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()
    
    return true
  }

}

