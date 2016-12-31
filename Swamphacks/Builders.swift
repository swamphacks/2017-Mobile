//
//  AnnouncementsViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/30/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

struct ModelTableViewControllerBuilder<T> {
  var build: (ModelTableViewController<T>) -> Void
  
  init(prepare: Bool = true, build: @escaping (ModelTableViewController<T>) -> Void) {
    self.build = { vc in
      if prepare {
        vc.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        vc.tableView.estimatedRowHeight = 90
        vc.tableView.separatorStyle = .none
      }
      build(vc)
    }
  }
}

let announcementsTableVCBuilder = ModelTableViewControllerBuilder<Announcement> { vc in
  vc.tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
  vc.title = "Announcements"
}

let happeningNowTableVCBuilder = ModelTableViewControllerBuilder<Event> { vc in
  vc.refreshable = false
  
  let headerHeight = UIScreen.main.bounds.height - 250
  let headerWidth = vc.tableView.bounds.width
  
  let countdownView = Bundle.main.loadNibNamed(CountdownView.defaultNibName,
                                               owner: nil,
                                               options: nil)!.first as! CountdownView
  countdownView.clipsToBounds = true
  
  vc.stickyHeader = (countdownView, headerHeight, headerWidth)

}
