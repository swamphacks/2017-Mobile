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

//TODO: Change fonts, and check in individual controllers

final class App {
  
  //MARK: Controllers
  
  lazy var root: UINavigationController = {
    let root: UINavigationController
    
    if FIRAuth.auth()?.currentUser == nil {
      root = LoginViewController(nibName: String(describing: LoginViewController.self), bundle: nil).rooted()
    } else {
      root = App.tabController().rooted()
    }
    
    root.isNavigationBarHidden = true
    return root
  }()
  
  static func tabController() -> UITabBarController {
    let tabController = UITabBarController()
    tabController.tabBar.tintColor = .turquoise
    tabController.tabBar.isTranslucent = false
    tabController.tabBar.barTintColor = .white
    
    tabController.viewControllers = [scheduleVC(), announcementsVC(), happeningNowVC(), sponsorsVC(), profileVC()].map { (vcTitleImage) -> UIViewController in
      vcTitleImage.0.topViewController?.title = vcTitleImage.1
      vcTitleImage.0.tabBarItem = tabBarItem(title: vcTitleImage.1, image: vcTitleImage.2)
      vcTitleImage.0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
      return vcTitleImage.0.styled()
    }
    
    tabController.selectedIndex = 2
    return tabController //.styled()
  }
 
  //MARK: View Controllers
  
  fileprivate static func scheduleVC() -> (UINavigationController, String, UIImage) {
    let events = { (completion: @escaping ([Event]) -> ()) in
      let resource = FirebaseResource<Event>(path: "events", parseJSON: Event.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrdered(byChild: "startTime"), .childAdded) }) { result in
        guard let event = result.value else { completion([]); return }
        completion([event])
      }
    }
    
    let scheduleVC = ScheduleViewController(events: events)
    scheduleVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    let navController = scheduleVC.rooted().styled()
    let image = UIImage(named: "event")!
    
    return (navController, "Events", image)
  }
  
  fileprivate static let filterVC = FilterTableViewController(nibName: nil, bundle: nil)
  
  fileprivate static func announcementsVC() -> (UINavigationController, String, UIImage) {
    let announcements = { (completion: @escaping ([Announcement]) -> ()) in
      let resource = FirebaseResource<Announcement>(path: "announcements", parseJSON: Announcement.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0, .childAdded) }) { result in
        guard let announcement = result.value else { completion([]); return }
        DispatchQueue.main.async { completion([announcement]) }
      }
    }
    
    let announcementsVC = ModelTableViewController(isIncremental: true,
                                                   load: announcements,
                                                   cellDescriptor: { $0.cellDescriptor },
                                                   rowHeight: { _,_ in .automatic })
    
    announcementsTableVCBuilder.build(announcementsVC)
    
    let timer = Timer(timeInterval: 60 * 5, repeats: true) { [weak announcementsVC] _ in
      announcementsVC?.localReload()
    }
    
    RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    
    let navController = announcementsVC.rooted()
    let image = UIImage(named: "announcement")!
            
    filterVC.title = "Filters"
    filterVC.tableView.separatorStyle = .none
    filterVC.automaticallyAdjustsScrollViewInsets = false
    filterVC.edgesForExtendedLayout = []
        
    announcementsVC.rightItem = (UIImage(named: "filter"), .plain)
    announcementsVC.didChooseRightItem = { [weak announcementsVC, weak filterVC] item in
      guard let vc = filterVC else { return }
      announcementsVC?.present(vc.rooted().styled(), animated: true, completion: nil)
    }
    
    announcementsVC.filter = { [weak filterVC] in
      let now = Date()
      return $0.filter { announcement -> Bool in
        var inFilters = true
        if let vc = filterVC {
          inFilters = (vc.filters[announcement.type.lowercased()]! == true)
        }
        return inFilters && announcement.date.compare(now) == .orderedAscending
      }
    }
    
    return (navController, "Announcements", image)
  }
  
  fileprivate static func happeningNowVC() -> (UINavigationController, String, UIImage) {
    let events = { (completion: @escaping ([Event]) -> ()) in
      let resource = FirebaseResource<Event>(path: "events", parseJSON: Event.init)
      _ = FirebaseManager.shared.observe(resource, queryEventType: { ($0.queryOrdered(byChild: "startTime"), .childAdded) }) { result in
        guard let event = result.value else { completion([]); return }
        completion([event])
      }
    }
    
    let happeningNowVC = ModelTableViewController(isIncremental: true,
                                                  load: events,
                                                  cellDescriptor: { $0.cellDescriptor },
                                                  rowHeight: { _,_ in .automatic })
    
    happeningNowVC.filter = {
      let hackathonStart = Date(timeIntervalSince1970: 1484967600)
      let now = Date() // Date(timeIntervalSince1970: 1485036000)
      
      if now.compare(hackathonStart) == .orderedAscending {
        let max = min($0.count, 3)
        return Array($0[0..<max])
      }
      
      return $0.filter { ($0.startTime..<$0.endTime).contains(now) }
    }
    
    happeningNowTableVCBuilder.build(happeningNowVC)
    
    let timer = Timer(timeInterval: 60 * 5, repeats: true) { [weak happeningNowVC] _ in
      happeningNowVC?.localReload()
    }
    
    RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    
    let navController = happeningNowVC.rooted()
    let image = UIImage(named: "clock")!
    
    navController.isNavigationBarHidden = true
    
    happeningNowVC.didSelect = { [weak navController] event in
      let eventVC = EventViewController(event: event)
      navController?.pushViewController(eventVC, animated: true)
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
    
    sponsorsVC.didSelect = { [weak navController] sponsor in
            
      let items = { (completion: @escaping ([DetailItem<Rep>]) -> ()) in
        var detailItems: [DetailItem<Rep>] = [.text(sponsor.description)]
        
        let repItems = sponsor.reps.map({DetailItem.item($0)})
        detailItems.append(contentsOf: repItems)
        
        completion(detailItems)
      }
      
      let sponsorVC = ModelTableViewController(load: items,
                                               cellDescriptor: { $0.cellDescriptor },
                                               rowHeight: { item, _ in
                                                switch item {
                                                case .text(_):
                                                  return .automatic
                                                case .item(_):
                                                  return .absolute(80)
                                                }
                                               })
      
      sponsorVC.title = sponsor.name
      sponsorVCTableVCBuilder.build(sponsorVC)
      
      sponsorVC.fabAction = { _ in
        return { _ in
          if UIApplication.shared.canOpenURL(sponsor.link) {
            UIApplication.shared.open(sponsor.link, options: [:], completionHandler: nil)
          }
        }
      }
      
      //*******************************
      
      let sponsorView = Bundle.main.loadNibNamed(SponsorView.defaultNibName,
                                                 owner: nil,
                                                 options: nil)!.first as! SponsorView
      sponsorView.sponsor = sponsor
      
      let headerWidth = sponsorVC.tableView.bounds.width
      let headerHeight: CGFloat = 149 + 84
      
      sponsorView.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
      sponsorVC.tableView.tableHeaderView = sponsorView
      
      //*******************************

      
      navController?.pushViewController(sponsorVC, animated: true)
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
    user.prepareInfoIfNeeded()
    user.prepareQRCodeIfNeeded()
  }
  
}
