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
      // load announcements from Firebase...
      let announcements = [Announcement(title: "Title", description: "This is a really long description. Watch out! There's a bear on the loose. He is taking mentorship requests and passing out a couple of snacks.", dateString: "Sat 9:00am"),
                           Announcement(title: "Hacker Registration", description: "There's a bear!", dateString: "Sat 3:00pm")] 
      
      completionHandler(announcements)
    }
    
    let announcementsVC = ModelTableViewController(load: announcementLoader,
                                                   cellDescriptor: { $0.cellDescriptor },
                                                   rowHeight: { _,_ in .automatic },
                                                   didSelect: { _ in })
    
    // Need this for .automatic rowHeight to work. Should probably throw error if we don't have it when we need it.
    announcementsVC.tableView.estimatedRowHeight = 90
    
    announcementsVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
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

