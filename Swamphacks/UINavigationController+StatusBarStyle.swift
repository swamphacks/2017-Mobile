//
//  UINavigationController+StatusBarStyle.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    return self.topViewController
  }
  
}
