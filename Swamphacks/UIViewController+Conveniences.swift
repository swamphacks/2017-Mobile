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
  
  enum AlertType {
    case generic
    case message(String, String?)
    case error(Error)
  }
  
  func showAlert(ofType type: AlertType, handler: ((UIAlertAction) -> ())? = nil) {
    let alertVC = UIAlertController(title: "Error", message: "Something went wrong, please try again later.", preferredStyle: .alert)
    
    switch type {
    case .generic:
      break
    case .message(let title, let message):
      alertVC.title = title
      alertVC.message = message
    case .error(let error):
      alertVC.message = error.localizedDescription
    }
    
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true, completion: nil)
  }
  
}
