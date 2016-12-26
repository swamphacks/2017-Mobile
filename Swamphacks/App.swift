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
  return tabController
}

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
  
  announcementsVC.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
  announcementsVC.tableView.separatorStyle = .none
  announcementsVC.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
  
  return announcementsVC.rooted()
}

fileprivate func happeningNowVC() -> UIViewController {
  let happeningNowVC = HappeningNowViewController(nibName: String(describing: HappeningNowViewController.self), bundle: nil).rooted()
  happeningNowVC.isNavigationBarHidden = true
  return happeningNowVC
}

fileprivate func profileVC() -> UIViewController {
  let happeningNowVC = ProfileViewController(nibName: String(describing: ProfileViewController.self), bundle: nil).rooted()
  happeningNowVC.isNavigationBarHidden = true
  return happeningNowVC
}
