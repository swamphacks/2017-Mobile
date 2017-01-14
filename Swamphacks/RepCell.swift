//
//  RepCell.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/13/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class RepCell: UITableViewCell {
  @IBOutlet weak var repImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    repImageView.layer.cornerRadius = repImageView.bounds.height/2
  }
}
