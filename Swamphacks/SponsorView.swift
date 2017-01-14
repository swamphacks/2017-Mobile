//
//  SponsorView.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/13/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

class SponsorView: UIView {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  var sponsor: Sponsor! {
    didSet {
      imageView.image = sponsor.logoImage
      nameLabel.text = "\(sponsor.name) | \(sponsor.location)"
    }
  }
  
}
