//
//  Announcement.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

struct Announcement {
  let title: String
  let description: String
  let dateString: String
}

extension Announcement {
  func configureCell(_ cell: AnnouncementCell) {
    cell.titleLabel?.text = title
    cell.descriptionLabel?.text = description
    cell.dateLabel?.text = dateString
  }
}

extension Announcement {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "announcementCell", registerMode: .withNib(AnnouncementCell.nib), configure: configureCell)
  }
}

