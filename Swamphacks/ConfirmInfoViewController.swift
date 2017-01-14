//
//  ConfirmInfoViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/14/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

class ConfirmInfoViewController: UIViewController {
  
  fileprivate let nameLabel: UILabel
  fileprivate let emailLabel: UILabel
  fileprivate let schoolLabel: UILabel
  fileprivate let confirmButton: UIButton
  
  let userInfo: UserInfo
  
  init(userInfo: UserInfo) {
    confirmButton = UIButton(type: .system)
    
    nameLabel = UILabel(frame: .zero)
    emailLabel = UILabel(frame: .zero)
    schoolLabel = UILabel(frame: .zero)
    
    for label in [nameLabel, emailLabel, schoolLabel] {
      label.font = UIFont.systemFont(ofSize: 17)
      label.textColor = .black
    }
    
    self.userInfo = userInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Confirm Attendee"
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(handleCloseButton(_:)))
    setUpViews()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Set Up
  
  fileprivate func setUpViews() {
    setUpNameLabels()
    setUpEmailLabels()
    setUpSchoolLabels()
    setUpConfirmButton()
  }
  
  fileprivate func setUpNameLabels() {
    let nameHeaderLabel = headerLabel()
    nameHeaderLabel.text = "Name"
    
    nameHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameHeaderLabel)
    
    let nameHeaderTop = nameHeaderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
    let nameHeaderLeft = nameHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22)
    
    NSLayoutConstraint.activate([nameHeaderTop, nameHeaderLeft])
    
    setUpLabel(label: nameLabel, text: userInfo.name, under: nameHeaderLabel)
  }
  
  fileprivate func setUpEmailLabels() {
    let emailHeader = headerLabel()
    setUpLabel(label: emailHeader, text: "Email", under: nameLabel, by: 16)
    setUpLabel(label: emailLabel, text: userInfo.email, under: emailHeader)
  }
  
  fileprivate func setUpSchoolLabels() {
    let schoolHeader = headerLabel()
    setUpLabel(label: schoolHeader, text: "University", under: emailLabel, by: 16)
    setUpLabel(label: schoolLabel, text: userInfo.school, under: schoolHeader)
  }
  
  fileprivate func setUpConfirmButton() {
    confirmButton.layer.masksToBounds = true
    confirmButton.layer.cornerRadius = 30
    confirmButton.backgroundColor = .turquoise
    
    confirmButton.setTitle("Confirm", for: .normal)
    confirmButton.tintColor = .white
    confirmButton.titleLabel?.textColor = .white
    confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    
    confirmButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(confirmButton)
    
    let centerX = confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let bottom = confirmButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -32)
    let width = confirmButton.widthAnchor.constraint(equalToConstant: 200)
    let height = confirmButton.heightAnchor.constraint(equalToConstant: 60)
    
    NSLayoutConstraint.activate([centerX, bottom, width, height])
    
    confirmButton.addTarget(self, action: #selector(handleConfirmButton(_:)), for: .touchUpInside)
    
    let confirmLabel = headerLabel()
    confirmLabel.text = "correct info?"
    
    confirmLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(confirmLabel)
    
    let confirmBottom = confirmLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -4)
    let confirmCenterX = confirmLabel.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor)
    
    NSLayoutConstraint.activate([confirmBottom, confirmCenterX])
  }
  
  //MARK: Actions
  
  @objc fileprivate func handleConfirmButton(_ button: UIButton?) {
    
  }
  
  @objc fileprivate func handleCloseButton(_ button: UIBarButtonItem?) {
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: Helpers
  
  fileprivate func setUpLabel(label: UILabel, text: String, under prev: UILabel, by constant: CGFloat = 4) {
    label.text = text
    
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    let nameTop = label.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: constant)
    let nameLeft = label.leftAnchor.constraint(equalTo: prev.leftAnchor)
    
    NSLayoutConstraint.activate([nameTop, nameLeft])
  }
  
  fileprivate func headerLabel() -> UILabel {
    let header = UILabel(frame: .zero)
    header.font = UIFont.systemFont(ofSize: 12)
    header.textColor = .turquoise
    return header
  }
  
}
