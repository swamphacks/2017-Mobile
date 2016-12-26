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
    window = UIWindow(frame: UIScreen.main.bounds)
    
    FIRApp.configure()
    
    let happeningNowVC = HappeningNowViewController(nibName: String(describing: HappeningNowViewController.self), bundle: nil)
    
    //******************************************
    
    let announcements = { (completion: @escaping ([Announcement]) -> ()) in
      let resource = FirebaseResource<Announcement>(path: "announcements", parseJSON: Announcement.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrderedByKey(), .childAdded) }) { result in
        guard let announcement = result.value else { return }
        completion([announcement])
      }
    }
    
    let announcementsVC = ModelTableViewController(isIncremental: true,
                                                   load: announcements,
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

