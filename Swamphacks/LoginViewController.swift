//
//  LoginViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/10/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    emailTextField.layer.cornerRadius = emailTextField.bounds.height/2
    passwordTextField.layer.cornerRadius = passwordTextField.bounds.height/2
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
