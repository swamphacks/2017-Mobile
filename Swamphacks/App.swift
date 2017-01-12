//
//  App.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {  
  var app: App {
    return (UIApplication.shared.delegate as! AppDelegate).app
  }
}

//TODO: Add ScheduleVC, SponsorVC, ConfirmVC, and check TODOs in individual controllers

final class App {
  
  //MARK: Controllers
  
  lazy var root: UIViewController = {
    if FIRAuth.auth()?.currentUser == nil {
      let root = LoginViewController(nibName: String(describing: LoginViewController.self), bundle: nil).rooted()
      root.isNavigationBarHidden = true
      return root
    }
    
    return App.tabController()
  }()
  
  static func tabController() -> UITabBarController {
    let tabController = UITabBarController()
    tabController.tabBar.tintColor = .turquoise
    tabController.tabBar.isTranslucent = false
    tabController.tabBar.barTintColor = .white
    
    tabController.viewControllers = [announcementsVC(), happeningNowVC(), sponsorsVC(), profileVC()].map { (vcTitleImage) -> UIViewController in
      vcTitleImage.0.topViewController?.title = vcTitleImage.1
      vcTitleImage.0.tabBarItem = tabBarItem(title: vcTitleImage.1, image: vcTitleImage.2)
      return vcTitleImage.0.styled()
    }
    
    return tabController //.styled()
  }
 
  //MARK: View Controllers
  
  fileprivate static func announcementsVC() -> (UINavigationController, String, UIImage) {
    let announcements = { (completion: @escaping ([Announcement]) -> ()) in
      let resource = FirebaseResource<Announcement>(path: "announcements", parseJSON: Announcement.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0, .childAdded) }) { result in
        guard let announcement = result.value else { completion([]); return }
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
    
    //TODO: left bar button to filter by announcement type?
    
    return (navController, "Announcements", image)
  }
  
  fileprivate static func happeningNowVC() -> (UINavigationController, String, UIImage) {
    let events = { (completion: @escaping ([Event]) -> ()) in
      let resource = FirebaseResource<Event>(path: "events", parseJSON: Event.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrdered(byChild: "startTime"), .childAdded) }) { result in
        let now = Date()
        guard let event = result.value, now.compare(event.endTime) == .orderedAscending else { completion([]); return }
        completion([event])
      }
    }
    
    let happeningNowVC = ModelTableViewController(isIncremental: true,
                                                  load: events,
                                                  cellDescriptor: { $0.cellDescriptor },
                                                  rowHeight: { _,_ in .automatic })
    
    happeningNowTableVCBuilder.build(happeningNowVC)
    
    let navController = happeningNowVC.rooted()
    let image = UIImage(named: "clock")!
    
    navController.isNavigationBarHidden = true
    
    happeningNowVC.didSelect = { event in
      let eventVC = EventViewController(event: event)
      navController.pushViewController(eventVC, animated: true)
    }
    
    return (navController, "Now", image)
  }
  
  fileprivate static func sponsorsVC() -> (UINavigationController, String, UIImage) {
    let sponsors = { (completion: @escaping ([Sponsor]) -> ()) in
      let resource = FirebaseResource<Sponsor>(path: "sponsors", parseJSON: Sponsor.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrdered(byChild: "startTime"), .childAdded) }) { result in
        guard let sponsor = result.value else { completion([]); return }
        completion([sponsor])
      }
    }
    
    let sponsorsVC = ModelTableViewController(isIncremental: true,
                                              load: sponsors,
                                              cellDescriptor: { $0.cellDescriptor },
                                              rowHeight: { _,_ in .absolute(90) })
    
    sponsorsTableVCBuilder.build(sponsorsVC)
    
    let navController = sponsorsVC.rooted()
    let image = UIImage(named: "suitcase")!
    
    sponsorsVC.didSelect = { sponsor in
      //TODO: show SponsorVC
    }
    
    return (navController, "Sponsors", image)
  }
  
  fileprivate static func profileVC() -> (UINavigationController, String, UIImage) {
    let profileVC = ProfileViewController(nibName: String(describing: ProfileViewController.self),
                                          bundle: nil).rooted()
    profileVC.isNavigationBarHidden = true
    
    let image = UIImage(named: "person")!
    return (profileVC, "Profile", image)
  }
  
  //MARK: Helpers
  
  fileprivate static func tabBarItem(title: String, image: UIImage) -> UITabBarItem {
    //TODO: change the images in .xcassets to be whatever color I want the unselected ones to be.
    // Then set image: here to image.applying(alpha: 0.7).withRenderingMode(.alwaysOriginal)
    return UITabBarItem(title: title,
                        image: image,
                        selectedImage: image)
  }
  
}

extension App {

  func prepare(user: FIRUser) {
    user.getInfo(useCache: false, completion: { _ in })
  }
  
}
