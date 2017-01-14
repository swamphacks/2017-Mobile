//
//  AnnouncementCell.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/24/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

//TODO: Don't let the date lable truncate. Shrink titleLabel's font instead. Use compression priority.
final class AnnouncementCell: UITableViewCell {
  @IBOutlet weak var typeIndicatorView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
}
