//
//  FilterCell.swift
//  Swamphacks
//
//  Created by Nikhil Thota on 1/15/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

protocol FilterCellDelegate: class {
  func filterCell(_ filterCell: FilterCell, updatedSwitchTo value: Bool)
}

final class FilterCell: UITableViewCell {
  
  @IBOutlet weak var filterLabel: UILabel!
  @IBOutlet weak var filterSwitch: UISwitch!
  
  weak var delegate: FilterCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    filterSwitch.addTarget(self, action: #selector(FilterCell.switchValueChanged), for: UIControlEvents.valueChanged)
  }
    
  func switchValueChanged(){
    delegate?.filterCell(self, updatedSwitchTo: filterSwitch.isOn)
  }
  
}
