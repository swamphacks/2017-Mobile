//
//  LoginViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/10/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit
import Firebase

final class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.returnKeyType = .next
    passwordTextField.returnKeyType = .go
    
    loginButton.layer.borderColor = UIColor.white.cgColor
    loginButton.layer.borderWidth = 2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    func styleTextField(_ textField: UITextField) {
      textField.layer.cornerRadius = textField.bounds.height/2
      
      let v = UIView(frame: CGRect(x: 0,
                                   y: 0,
                                   width: textField.layer.cornerRadius,
                                   height: textField.bounds.height))
      textField.leftView = v
      textField.leftViewMode = .always
      
      textField.rightView = v
      textField.rightViewMode = .always
    }
    
    styleTextField(emailTextField)
    styleTextField(passwordTextField)
    
    loginButton.layer.cornerRadius = loginButton.bounds.height/2
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Login
  
  @IBAction func login(_ sender: UIButton?) {
    guard let email = emailTextField.text else {
      emailTextField.becomeFirstResponder()
      return
    }
    
    guard let password = passwordTextField.text else {
      passwordTextField.becomeFirstResponder()
      return
    }
    
    guard let auth = FIRAuth.auth() else {
      showAlert(ofType: .generic)
      return
    }
    
    //TODO: loading indicator
    auth.signIn(withEmail: email, password: password) { (_, error) in
      if let e = error {
        self.showAlert(ofType: .error(e))
        return
      }
      self.goNext()
    }
  }
  
  //MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (textField == emailTextField) {
      passwordTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
      login(nil)
    }
    return true
  }
  
  //MARK: Navigation
  
  fileprivate func goNext() {
    navigationItem.hidesBackButton = true
    show(App.tabController(), sender: self)
  }
  
  //MARK: Helpers
  
  enum AlertType {
    case generic
    case message(String, String?)
    case error(Error)
  }
  
  fileprivate func showAlert(ofType type: AlertType) {
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
    
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alertVC.addAction(okAction)

    present(alertVC, animated: true, completion: nil)
  }
  
}
