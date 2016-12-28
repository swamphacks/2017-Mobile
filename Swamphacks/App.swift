//
//  App.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

func root() -> UIViewController {
  let tabController = UITabBarController()
  tabController.viewControllers = [announcementsVC(), happeningNowVC(), profileVC()]
  
  tabController.tabBar.tintColor = .turquoise
  tabController.tabBar.isTranslucent = false
  tabController.tabBar.barTintColor = .white
  
  tabController.tabBar.backgroundImage = nil
  tabController.tabBar.backgroundColor = nil
  tabController.tabBar.shadowImage = nil
  
  return tabController.styled()
}

//MARK: View Controllers

fileprivate func announcementsVC() -> UIViewController {
  let announcements = { (completion: @escaping ([Announcement]) -> ()) in
    let resource = FirebaseResource<Announcement>(path: "announcements", parseJSON: Announcement.init)
    _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0, .childAdded) }) { result in
      guard let announcement = result.value else { return }
      completion([announcement])
    }
  }
  
  let announcementsVC = ModelTableViewController(isIncremental: true,
                                                 load: announcements,
                                                 cellDescriptor: { $0.cellDescriptor },
                                                 rowHeight: { _,_ in .automatic },
                                                 didSelect: { _ in })
  
  announcementsVC.tableView.estimatedRowHeight = 90 // Need this for .automatic rowHeight to work. Want better way to do this w/ ModelTableVC.
  
  announcementsVC.title = "Announcements"
  announcementsVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
  announcementsVC.tableView.separatorStyle = .none
  announcementsVC.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
  
  let navController = announcementsVC.rooted()
  
  let image = UIImage(named: "announcement")!
  navController.tabBarItem = tabBarItem(title: announcementsVC.title!, image: image)
  
  return navController.styled()
}

fileprivate func happeningNowVC() -> UIViewController {
  let events = { (completion: @escaping ([Event]) -> ()) in
    let resource = FirebaseResource<Event>(path: "events", parseJSON: Event.init)
    _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0, .childAdded) }) { result in
      guard let event = result.value else { return }
      completion([event])
    }
  }
  
  let happeningNowVC = ModelTableViewController(isIncremental: true,
                                                load: events,
                                                cellDescriptor: { $0.cellDescriptor },
                                                rowHeight: { _,_ in .automatic },
                                                didSelect: { _ in })
  
  happeningNowVC.tableView.estimatedRowHeight = 90
  
  happeningNowVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
  happeningNowVC.tableView.separatorStyle = .none
  happeningNowVC.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)

  let navController = happeningNowVC.rooted()
  navController.isNavigationBarHidden = true

  let image = UIImage(named: "clock")!
  navController.tabBarItem = tabBarItem(title: "Now", image: image)
  
  /*
  progressView.padding = 16
  progressView.lineWidth = 32
  progressView.setProgress(0.85, animated: false)
  */
  
  return navController.styled()
}

fileprivate func profileVC() -> UIViewController {
  let profileVC = ProfileViewController(nibName: String(describing: ProfileViewController.self), bundle: nil).rooted()
  profileVC.isNavigationBarHidden = true
  let image = UIImage(named: "person")!
  profileVC.tabBarItem = tabBarItem(title: "Profile", image: image)
  return profileVC.styled()
}

//MARK: Helpers

fileprivate func tabBarItem(title: String, image: UIImage) -> UITabBarItem {
 return UITabBarItem(title: title,
                     image: image,
                     selectedImage: image)
}
