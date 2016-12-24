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
  let date: Date
}

//TODO: Create AnnouncementCell.xib, wire up the outlets and implement `configureCell(_ cell:)`
final class AnnouncementCell: UITableViewCell {

}

extension Announcement {
  func configureCell(_ cell: AnnouncementCell) {
    cell.textLabel?.text = title
  }
}

extension Announcement {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "announcementCell", registerMode: .withNib(AnnouncementCell.nib), configure: configureCell)
  }
}

