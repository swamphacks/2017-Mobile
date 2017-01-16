//
//  EventCell.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/28/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class EventCell: UITableViewCell {
  @IBOutlet weak var typeIndicatorView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    alpha = highlighted ? 0.4 : 1
  }
}
