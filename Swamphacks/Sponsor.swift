//
//  Sponsor.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/3/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

struct Sponsor {
  let name: String
  let description: String
  let link: URL
  let reps: [Rep]
  let tier: String
  let logoImage: UIImage?
}

extension Sponsor {
  init?(json: JSONDictionary) {
    guard let name = json["name"] as? String,
          let description = json["description"] as? String,
          let path = json["link"] as? String,
          let link = URL(string: path),
          let repsDict = json["reps"] as? JSONDictionary,
          let tier = json["tier"] as? String,
          let logoStr = json["logo"] as? String
    else {
      print("Failed to load Sponsor from json \(json)")
      return nil
    }
    
    self.name = name
    self.description = description
    self.link = link
    self.tier = tier
    
    if let data = Data(base64Encoded: logoStr) {
      self.logoImage = UIImage(data: data)
    } else {
      self.logoImage = nil
    }
    
    var reps = [Rep]()
    for key in repsDict.keys {
      guard let json = repsDict[key] as? JSONDictionary else { continue }
      if let rep = Rep(json: json) {
        reps.append(rep)
      }
    }
    
    self.reps = reps
  }
}

struct Rep {
  let name: String
  let title: String
  let image: UIImage?
}

extension Rep {
  init?(json: JSONDictionary) {
    guard let name = json["name"] as? String,
          let title = json["title"] as? String,
          let imageStr = json["image"] as? String
    else {
      print("Failed to load Rep from json \(json)")
      return nil
    }
    
    self.name = name
    self.title = title
    
    if let data = Data(base64Encoded: imageStr) {
      self.image = UIImage(data: data)
    } else {
      self.image = nil
    }
  }
}

extension Sponsor {
  func configureCell(_ cell: SponsorCell) {
    cell.sponsorImageView.image = logoImage
    //TODO: typeIndicatorView backgroundColor based on tier
  }
}

extension Sponsor {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "sponsorCell",
                          registerMode: .withNib(SponsorCell.nib),
                          configure: configureCell)

  }
}