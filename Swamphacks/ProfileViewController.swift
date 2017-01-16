//
//  ProfileViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import AVFoundation

import Firebase
import MMMaterialDesignSpinner

class ProfileViewController: UIViewController {  
  @IBOutlet weak fileprivate var logoutButton: UIButton!
  @IBOutlet weak fileprivate var cameraButton: UIButton!
  
  @IBOutlet weak fileprivate var emailTextField: UITextField!
  @IBOutlet weak fileprivate var submitEmailButton: UIButton!
  fileprivate var spinner: MMMaterialDesignSpinner!

  @IBOutlet weak fileprivate var displayNameLabel: UILabel!
  @IBOutlet weak fileprivate var emailLabel: UILabel!
  
  @IBOutlet weak var generateQRCodeButton: UIButton!
  @IBOutlet weak var qrCodeContainer: UIView!
  @IBOutlet weak var qrCodeImageView: UIImageView!

  @IBOutlet weak var volunteerContainerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    view.addGestureRecognizer(tap)
    
    submitEmailButton.layer.borderColor = UIColor.white.cgColor
    submitEmailButton.layer.borderWidth = 2
    
    qrCodeContainer.layer.cornerRadius = 16
    
    generateQRCodeButton.layer.borderColor = UIColor.white.cgColor
    generateQRCodeButton.layer.borderWidth = 2
    generateQRCodeButton.isHidden = true
    
    emailTextField.returnKeyType = .go
    
    displayNameLabel.text = nil
    emailLabel.text = nil
    
    setUp()
    
    if let user = FIRAuth.auth()?.currentUser {
      user.getInfo(completion: { userInfo in
        self.displayNameLabel.text = userInfo?.name
        self.emailLabel.text = userInfo?.email
        self.setUp(with: userInfo)
      })
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
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
    submitEmailButton.layer.cornerRadius = submitEmailButton.bounds.height/2
    generateQRCodeButton.layer.cornerRadius = generateQRCodeButton.bounds.height/2
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Set Up
  
  fileprivate func setUp() {
    setUpSpinner()
  }
  
  fileprivate func setUpSpinner() {
    spinner = MMMaterialDesignSpinner(frame: .zero)
    spinner.tintColor = .turquoise
    spinner.lineWidth = 3
    spinner.hidesWhenStopped = true
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.addSubview(spinner)
    
    let right = spinner.rightAnchor.constraint(equalTo: emailTextField.rightAnchor, constant: -(emailTextField.bounds.height * 0.40)/2)
    let centerY = spinner.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor)
    let width = spinner.widthAnchor.constraint(equalToConstant: emailTextField.bounds.height * 0.40)
    let aspect = spinner.heightAnchor.constraint(equalTo: spinner.widthAnchor, multiplier: 1)
    
    NSLayoutConstraint.activate([right, centerY, width, aspect])
  }
  
  fileprivate func setUp(with info: UserInfo?) {
    let isVolunteer = info?.isVolunteer ?? false
    volunteerContainerView.isHidden = !isVolunteer
    
    if !isVolunteer {
      getQRCode()
    }
  }
  
  fileprivate func getQRCode() {
    generateQRCodeButton.isEnabled = false
    FIRAuth.auth()?.currentUser?.getQRCode() { image in
      self.setQRCode(to: image)
      self.generateQRCodeButton.isEnabled = true
    }
  }
  
  fileprivate func setQRCode(to image: UIImage?) {
    self.generateQRCodeButton.isHidden = (image != nil)
    self.qrCodeImageView.image = image

  }
  
  //MARK: Actions
  
  @IBAction func handleCameraButton(_ sender: AnyObject?) {
    app.scanVC.mode = .confirm
    app.scanVC.shouldScan = true
    present(app.scanVC.rooted().styled(), animated: true, completion: nil)
  }
  
  @IBAction func submitEmail(_ sender: UIButton?) {
    guard let email = emailTextField.text, !email.isEmpty else {
      emailTextField.becomeFirstResponder()
      return
    }
    
    setLoading(true)
    FirebaseManager.shared.getInfo(forUserEmail: email) { [weak self] userInfo in
      guard let strongSelf = self else { return }
      strongSelf.setLoading(false)
      
      guard let info = userInfo else {
        strongSelf.showAlert(ofType: .message("Error", "Something went wrong. Please check that the email is correct."))
        return
      }
      
      let vc = ConfirmInfoViewController(userInfo: info).rooted().styled()
      strongSelf.present(vc, animated: true, completion: nil)
    }
    
  }
  
  @IBAction func generateQRCode(_ sender: UIButton?) {
    getQRCode()
  }
  
  @IBAction func logout(_ sender: UIButton?) {
    let alertVC = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
    
    let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { [weak self] action in
      guard let _self = self else { return }
      let root = _self.app.root
      
      if let _ = root.viewControllers.first as? UITabBarController {
        let loginVC = LoginViewController(nibName: String(describing: LoginViewController.self), bundle: nil)
        root.viewControllers.insert(loginVC, at: 0)
      }
      
      _ = root.popToRootViewController(animated: false)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    alertVC.addAction(logoutAction)
    alertVC.addAction(cancelAction)
    
    present(alertVC, animated: true, completion: nil)
  }
  
  //MARK: Gestures
  
  @objc fileprivate func handleTap(_ tap: UIGestureRecognizer) {
    if emailTextField.isFirstResponder {
      emailTextField.resignFirstResponder()
    }
  }
  
  //MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text, !text.isEmpty else {
      return false
    }
    
    textField.resignFirstResponder()
    submitEmail(nil)
    
    return true
  }
  
  //MARK: Helpers
  
  fileprivate func setLoading(_ loading: Bool) {
    spinner.setAnimating(loading)
  }
}
