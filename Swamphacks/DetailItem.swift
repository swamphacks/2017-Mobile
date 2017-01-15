//
//  DetailItem.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/15/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import Foundation

protocol CellDescriber {
  var cellDescriptor: CellDescriptor { get }
}

enum DetailItem<Model: CellDescriber> {
  case text(String)
  case item(Model)
  
  var cellDescriptor: CellDescriptor {
    switch self {
    case .text(let str):
      func configure(cell: LabelCell) {
        cell.label?.text = str
      }
      return CellDescriptor(reuseIdentifier: "text",
                            registerMode: .withNib(LabelCell.nib),
                            configure: configure)
    case .item(let model):
      return model.cellDescriptor
    }
  }
}
