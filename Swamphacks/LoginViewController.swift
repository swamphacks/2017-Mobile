//
//  LoginViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/10/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class PaddedTextField: UITextField {
  var padding: (left: CGFloat, right: CGFloat) = (0, 0) {
    didSet {
      layoutIfNeeded()
    }
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding.left, dy: padding.right)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding.left, dy: padding.right)
  }
}

final class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: PaddedTextField!
  @IBOutlet weak var passwordTextField: PaddedTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    emailTextField.layer.cornerRadius = emailTextField.bounds.height/2
    passwordTextField.layer.cornerRadius = passwordTextField.bounds.height/2
    
    emailTextField.padding = (emailTextField.layer.cornerRadius, emailTextField.layer.cornerRadius)
    passwordTextField.padding = (passwordTextField.layer.cornerRadius, passwordTextField.layer.cornerRadius)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
