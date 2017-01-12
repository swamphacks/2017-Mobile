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

let sponsorsTableVCBuilder = ModelTableViewControllerBuilder<Sponsor> { vc in
  vc.sections = { vc in
    var sections = 1
    if (vc.items.filter({ $0.tier.caseInsensitiveCompare("Turtle") == .orderedSame }).count > 0) {
      sections += 1
    }
    if (vc.items.filter({ $0.tier.caseInsensitiveCompare("Lily Pad") == .orderedSame }).count > 0) {
      sections += 1
    }
    return sections
  }
  
  vc.rowsInSection = { section in
    switch section {
    case 0:
      return vc.items.filter({ $0.tier.caseInsensitiveCompare("Heron") == .orderedSame }).count
    case 1:
      return vc.items.filter({ $0.tier.caseInsensitiveCompare("Turtle") == .orderedSame }).count
    case 2:
      return vc.items.filter({ $0.tier.caseInsensitiveCompare("Lily Pad") == .orderedSame }).count
    default:
      return 0
    }
  }
  
  vc.itemForIndexPath = { indexPath in
    switch indexPath.section {
    case 0:
      let items = vc.items.filter({ $0.tier.caseInsensitiveCompare("Heron") == .orderedSame })
      return items[indexPath.row]
    case 1:
      let items = vc.items.filter({ $0.tier.caseInsensitiveCompare("Turtle") == .orderedSame })
      return items[indexPath.row]
    case 2:
      let items = vc.items.filter({ $0.tier.caseInsensitiveCompare("Lily Pad") == .orderedSame })
      return items[indexPath.row]
    default:
      return nil
    }
  }
  
  vc.header = { section in
    let tier: String
    let count: Int
    switch section {
    case 0:
      count = vc.items.filter({ $0.tier.caseInsensitiveCompare("Heron") == .orderedSame }).count
      tier = "Heron Tier"
    case 1:
      count = vc.items.filter({ $0.tier.caseInsensitiveCompare("Turtle") == .orderedSame }).count
      tier = "Turtle Tier"
    case 2:
      count = vc.items.filter({ $0.tier.caseInsensitiveCompare("Lily Pad") == .orderedSame }).count
      tier = "Lily Pad Tier"
    default:
      count = 0
      tier = ""
    }
    
    let label = PaddedLabel(frame: .zero)
    label.padding = UIEdgeInsets(top: 16, left: 24, bottom: 8, right: 0)
    label.backgroundColor = vc.view.backgroundColor
    label.text = tier
    label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
    
    let height: RowHeight = count == 0 ? .absolute(0) : .absolute(label.intrinsicContentSize.height)
    
    return (height, tier.isEmpty ? nil : .view(label))
  }
  
}
