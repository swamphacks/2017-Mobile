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
  let type: String
  
  fileprivate static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EE hh:mma"
    formatter.amSymbol = "am"
    formatter.pmSymbol = "pm"
    return formatter
  }()
  
  var dateString: String {
    return Announcement.dateFormatter.string(from: date)
  }
}

extension Announcement {
  init?(json: JSONDictionary) {
    guard let title = json["name"] as? String,
      let description = json["description"] as? String,
      let epoch = json["time"] as? TimeInterval,
      let type = json["type"] as? String
      else { return nil }

    self.title = title
    self.description = description
    self.date = Date(timeIntervalSince1970: epoch)
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

