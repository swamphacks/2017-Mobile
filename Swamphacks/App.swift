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
                                                 rowHeight: { _,_ in .automatic })
  

  prepare(tableVC: announcementsVC)
  announcementsVC.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
  
  announcementsVC.title = "Announcements"
  
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
                                                rowHeight: { _,_ in .automatic })
  
  prepare(tableVC: happeningNowVC)

  let navController = happeningNowVC.rooted()
  navController.isNavigationBarHidden = true

  let image = UIImage(named: "clock")!
  navController.tabBarItem = tabBarItem(title: "Now", image: image)
  
  let countdownView = Bundle.main.loadNibNamed(CountdownView.defaultNibName,
                                               owner: happeningNowVC,
                                               options: nil)?.first as! CountdownView
  
  countdownView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 440)
  happeningNowVC.tableView.tableHeaderView = countdownView

  //TODO: Fix the little top hole of grey somehow :(
  
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

fileprivate func prepare<T>(tableVC: ModelTableViewController<T>) {
  // Need this for .automatic rowHeight to work. Want better way to do this w/ ModelTableVC.
  tableVC.tableView.estimatedRowHeight = 90
  tableVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
  tableVC.tableView.separatorStyle = .none
}
