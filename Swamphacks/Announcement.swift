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
    else {
      print("Failed to load Announcement from json: \(json)")
      return nil
    }

    self.title = title
    self.description = description
    self.date = Date(timeIntervalSince1970: epoch)
    self.type = type
  }
}

extension Announcement {
  var color: UIColor {
    switch type {
    case "logistics":
      return UIColor(red: 249/255, green: 167/255, blue: 167/255, alpha: 1) // red
    case "social":
      return UIColor(red: 175/255, green: 239/255, blue: 249/255, alpha: 1) // blue
    case "food":
      return UIColor(red: 173/255, green: 178/255, blue: 251/255, alpha: 1) // purple
    case "techtalk":
      return UIColor(red: 192/255, green: 244/255, blue: 184/255, alpha: 1) // green
    case "sponsor":
      return UIColor(red: 255/255, green: 188/255, blue: 129/255, alpha: 1) // orange
    default:
      return .turquoise
    }
  }
}

extension Announcement {
  func configureCell(_ cell: AnnouncementCell) {
    cell.titleLabel?.text = title
    cell.descriptionLabel?.text = description
    cell.dateLabel?.text = dateString
    cell.typeIndicatorView.backgroundColor = color
  }
}

extension Announcement {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "announcementCell",
                          registerMode: .withNib(AnnouncementCell.nib),
                          configure: configureCell)
  }
}

