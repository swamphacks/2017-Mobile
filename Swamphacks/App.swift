//
//  App.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

//TODO: Add LoginVC, SponsorsVC and CalendarVC

func root() -> UIViewController {
  let tabController = UITabBarController()
  tabController.viewControllers = [announcementsVC(), happeningNowVC(), profileVC()]
  
  tabController.tabBar.tintColor = .turquoise
  tabController.tabBar.isTranslucent = false
  tabController.tabBar.barTintColor = .white
  
  return tabController //.styled()
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
                                                 rowHeight: { _,_ in .automatic })
  
  announcementsTableVCBuilder.build(announcementsVC)
  
  let navController = announcementsVC.rooted()
  
  let image = UIImage(named: "announcement")!
  navController.tabBarItem = tabBarItem(title: announcementsVC.title!, image: image)
  
  return navController.styled()
}

fileprivate func happeningNowVC() -> UIViewController {
  
  let events = { (completion: @escaping ([Event]) -> ()) in
    let resource = FirebaseResource<Event>(path: "events", parseJSON: Event.init)
    _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrdered(byChild: "startTime"), .childAdded) }) { result in
      let now = Date()
      guard let event = result.value, now.compare(event.startTime) == .orderedAscending else { return }
      completion([event])
    }
  }
  
  let happeningNowVC = ModelTableViewController(isIncremental: true,
                                                load: events,
                                                cellDescriptor: { $0.cellDescriptor },
                                                rowHeight: { _,_ in .automatic })
  
  happeningNowTableVCBuilder.build(happeningNowVC)
  
  let navController = happeningNowVC.rooted()
  navController.isNavigationBarHidden = true
  
  let image = UIImage(named: "clock")!
  navController.tabBarItem = tabBarItem(title: "Now", image: image)
  
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
  //TODO: change the images in .xcassets to be whatever color I want the unselected ones to be.
  // Then set image: here to image.applying(alpha: 0.7).withRenderingMode(.alwaysOriginal)
  return UITabBarItem(title: title,
                     image: image,
                     selectedImage: image)
}

fileprivate func prepare<T>(tableVC: ModelTableViewController<T>) {
  // Need this for .automatic rowHeight to work. Want better way to do this w/ ModelTableVC.
  tableVC.tableView.estimatedRowHeight = 90
  
  tableVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
  tableVC.tableView.separatorStyle = .none
}
