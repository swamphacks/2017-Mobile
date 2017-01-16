//
//  SponsorCell.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/3/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class SponsorCell: UITableViewCell {
  @IBOutlet weak var typeIndicatorView: UIView!
  @IBOutlet weak var sponsorImageView: UIImageView!
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    alpha = highlighted ? 0.4 : 1
  }
}
