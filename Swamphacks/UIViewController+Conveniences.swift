//
//  UIViewController+Conveniences.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func rooted() -> UINavigationController {
    return UINavigationController(rootViewController: self)
  }
  
}
