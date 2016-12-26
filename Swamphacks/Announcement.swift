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
  let type: String
}

extension Announcement {
  init?(json: JSONDictionary) {
    guard let title = json["name"] as? String,
      let description = json["description"] as? String,
      let dateString = json["time"] as? String,
      let type = json["type"] as? String
      else { return nil }

    self.title = title
    self.description = description
    self.dateString = dateString
    self.type = type
  }
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

