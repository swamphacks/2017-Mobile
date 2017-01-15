//
//  Event.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/28/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

struct Event {
  let title: String
  let description: String
  let startTime: Date
  let endTime: Date
  let location: String
  let attendees: Int
  let rating: Double
  let type: String
  let mapImage: UIImage?
}

extension Event {
  init?(json: JSONDictionary) {
    guard let title = json["name"] as? String,
          let description = json["description"] as? String,
          let startEpoch = json["startTime"] as? TimeInterval,
          let endEpoch = json["endTime"] as? TimeInterval,
          let location = json["location"] as? String,
          let attendees = json["numAttendees"] as? Int,
          let rating = json["avgRating"] as? Double,
          let type = json["type"] as? String,
          let mapImageStr = json["map"] as? String
    else {
      print("Failed to load Event from json: \(json)")
      return nil
    }
    
    self.title = title
    self.description = description
    self.startTime = Date(timeIntervalSince1970: startEpoch)
    self.endTime = Date(timeIntervalSince1970: endEpoch)
    self.location = location
    self.attendees = attendees
    self.rating = rating
    self.type = type
    
    if let data = Data(base64Encoded: mapImageStr, options: [.ignoreUnknownCharacters]) {
      self.mapImage = UIImage(data: data)
    } else {
      self.mapImage = nil
    }
  }
}

extension Event {
  var color: UIColor {
    switch type {
      case "logistics":
        return UIColor(red: 249/255, green: 167/255, blue: 167/255, alpha: 1) // red
      case "social":
        return UIColor(red: 192/255, green: 244/255, blue: 184/255, alpha: 1) // green
      case "food":
        return UIColor(red: 255/255, green: 188/255, blue: 129/255, alpha: 1) // orange
      case "techtalk":
        return UIColor(red: 173/255, green: 178/255, blue: 251/255, alpha: 1) // purple
    default:
      return .turquoise
    }
  }
}

extension Event {
  var timeInterval: Range<TimeInterval> {
    return startTime.timeIntervalSinceReferenceDate..<endTime.timeIntervalSinceReferenceDate
  }
}

extension Event {
  var classification: String {
    switch title {
    case "Pancake Art":
      return "main"
    case "Brain Bowl":
      return  "main"
    case "Musical Chairs":
      return "main"
    case "Balloon Battle":
      return "main"
    case "Ping Pong":
      return "main"
    case "Stepping Challenge":
      return "main"
    case "Paper Airplane":
      return "main"
    case "Youtube Karaoke":
      return "mini"
    case "Rock Paper Scissors":
      return "mini"
    case "Cup Stacking":
      return "mini"
    case "Bubble Wrap":
      return "mini"
    case "Branding Competition":
      return "mini"
    case "Smash Bros":
      return "mini"
    case "Yoga":
      return "mini"
    case "Soylent Art":
      return "mini"
    case "Cornhole":
      return "mini"
    default:
      return "mini"
    }
  }
  
}

extension Event {
  func configureCell(_ cell: EventCell) {
    cell.titleLabel?.text = title
    cell.locationLabel?.text = location
    cell.typeIndicatorView.backgroundColor = color
  }
}

extension Event {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "eventCell",
                          registerMode: .withNib(EventCell.nib),
                          configure: configureCell)
  }
}
