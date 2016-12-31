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
  
  //let map: UIImage?
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
      let type = json["type"] as? String
      //let mapImage = json["map"] as? String
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
    
    //TODO: load base-64 encoded map image from string
  }
}

extension Event {
  func configureCell(_ cell: EventCell) {
    cell.titleLabel?.text = title
    cell.locationLabel?.text = location
    //TODO: typeIndicatorView backgroundColor based on type
  }
}

extension Event {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "eventCell",
                          registerMode: .withNib(EventCell.nib),
                          configure: configureCell)
  }
}
