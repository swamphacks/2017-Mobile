//
//  SponsorView.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/13/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

class SponsorView: UIView {
  
  @IBOutlet fileprivate weak var imageView: UIImageView!
  @IBOutlet fileprivate weak var nameLabel: UILabel!
  @IBOutlet fileprivate weak var descriptionLabel: UILabel!
  
  var sponsor: Sponsor! {
    didSet {
      imageView.image = sponsor.logoImage
      nameLabel.text = "\(sponsor.name) | \(sponsor.location)"
      descriptionLabel.text = sponsor.description
    }
  }
  
}
