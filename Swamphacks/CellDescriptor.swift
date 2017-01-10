//
//  CellUtilities.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

enum CellRegisterMode {
  case withClass
  case withNib(UINib)
}

struct CellDescriptor {
  let cellClass: UITableViewCell.Type
  
  let reuseIdentifier: String
  let configure: (UITableViewCell) -> ()
  
  let registerMode: CellRegisterMode
  
  init<Cell: UITableViewCell>(reuseIdentifier: String, registerMode: CellRegisterMode, configure: @escaping (Cell) -> ()) {
    self.cellClass = Cell.self
    self.reuseIdentifier = reuseIdentifier
    self.registerMode = registerMode
    self.configure = { cell in
      configure(cell as! Cell)
    }
  }
}
