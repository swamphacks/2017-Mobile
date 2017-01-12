//
//  LoginViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/10/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit
import Firebase
import MMMaterialDesignSpinner

final class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var spinner: MMMaterialDesignSpinner!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.returnKeyType = .next
    passwordTextField.returnKeyType = .go
    
    loginButton.layer.borderColor = UIColor.white.cgColor
    loginButton.layer.borderWidth = 2
    
    spinner.tintColor = .white
    spinner.lineWidth = 4
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    view.addGestureRecognizer(tap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setLoading(false)
    emailTextField.text = nil
    passwordTextField.text = nil
    
    if let auth = FIRAuth.auth(), let user = auth.currentUser {
      user.purgeInfo()
      try? auth.signOut()
    }
    
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
    guard let email = emailTextField.text, !email.isEmpty else {
      emailTextField.becomeFirstResponder()
      return
    }
    
    guard let password = passwordTextField.text, !password.isEmpty else {
      passwordTextField.becomeFirstResponder()
      return
    }
    
    guard let auth = FIRAuth.auth() else {
      showAlert(ofType: .generic)
      return
    }
    
    setLoading(true)
    auth.signIn(withEmail: email, password: password) { (u, error) in
      if let e = error {
        self.setLoading(false)
        self.showAlert(ofType: .error(e))
        return
      }
      
      guard let user = u else {
        self.setLoading(false)
        self.showAlert(ofType: .generic)
        return
      }
      
      self.app.prepare(user: user)
      self.goNext()
    }
  }
  
  @IBAction func forgotPassword(_ sender: UIButton?) {
    guard let email = emailTextField.text, !email.isEmpty else {
      showAlert(ofType: .message("Email Needed", "We need your email to send a password reset email. Please enter it above."))
      return
    }
    
    guard let auth = FIRAuth.auth() else {
      showAlert(ofType: .generic)
      return
    }
    
    setLoading(true)
    auth.sendPasswordReset(withEmail: email) { err in
      self.setLoading(false)
      self.showAlert(ofType: err != nil ? .error(err!) : .message("Email Sent", "Please check your email in order to reset your password."))
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
  
  //MARK: Gestures
  
  @objc fileprivate func handleTap(_ tap: UIGestureRecognizer) {
    if emailTextField.isFirstResponder {
      emailTextField.resignFirstResponder()
    }
    
    if passwordTextField.isFirstResponder {
      passwordTextField.resignFirstResponder()
    }
  }
  
  //MARK: Navigation
  
  fileprivate func goNext() {
    navigationItem.hidesBackButton = true
    show(App.tabController(), sender: self)
  }
  
  //MARK: Helpers
  
  fileprivate func setLoading(_ loading: Bool) {
    spinner.setAnimating(loading)
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: [.beginFromCurrentState],
                   animations:
    {
      self.loadingView.alpha = loading ? 1 : 0
    },
                   completion: nil)
  }
}
