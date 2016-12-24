//
//  NibLoadable.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
  /// The name of the corresponding nib file
  static var defaultNibName: String { get }
}

extension NibLoadable {
  static var defaultNibName: String {
    return String(describing: self)
  }
  
  /// By default, use a nib with a name of `defaultNibName` and is located in the bundle of that class
  static var nib: UINib {
    return UINib(nibName: defaultNibName, bundle: Bundle(for: self))
  }
}

extension UITableViewCell: NibLoadable { }

extension UIViewController: NibLoadable { }

func controllerFromNib<T: UIViewController>() -> T where T: NibLoadable {
  return T(nibName: T.defaultNibName, bundle: Bundle(for: T.self))
}
