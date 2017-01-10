//
//  UINavigationController+StatusBarStyle.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

enum BorderLocation {
  case top, bottom
  
  func anchor(for view: UIView) -> NSLayoutYAxisAnchor {
    switch self {
    case .top: return view.topAnchor
    case .bottom: return view.bottomAnchor
    }
  }
}

extension UIView {
  
  func style(on location: BorderLocation, height: CGFloat, color: UIColor = .darkTurquoise) {
    let view = UIView(frame: .zero)
    view.backgroundColor = color
    
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    let borderAnchor = location.anchor(for: view).constraint(equalTo: location.anchor(for: self))
    let left = view.leftAnchor.constraint(equalTo: leftAnchor)
    let right = view.rightAnchor.constraint(equalTo: rightAnchor)
    let height = view.heightAnchor.constraint(equalToConstant: height)
    
    NSLayoutConstraint.activate([borderAnchor, left, right, height])
  }
  
}

extension UINavigationController {
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    return self.topViewController
  }
  
  func style() {
    return navigationBar.style(on: .bottom, height: 4)
  }
  
  func styled() -> UINavigationController {
    style()
    return self
  }
}

extension UITabBarController {
  func style() {
    return tabBar.style(on: .top, height: 2, color: .turquoise)
  }
  
  func styled() -> UITabBarController {
    style()
    return self
  }
}

extension UIImage {
  
  func applying(alpha:CGFloat) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    
    let ctx = UIGraphicsGetCurrentContext()!
    let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    ctx.scaleBy(x: 1, y: -1)
    ctx.translateBy(x: 0, y: -area.size.height)
    
    ctx.setBlendMode(.multiply)
    ctx.setAlpha(alpha)
    
    ctx.draw(cgImage!, in: area)
        
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
}
