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
    nameLabel = UILabel(frame: .zero)
    emailLabel = UILabel(frame: .zero)
    schoolLabel = UILabel(frame: .zero)
    confirmButton = UIButton(frame: .zero)
    
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
    title = "Confirm User"
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(handleCloseButton(_:)))
    setUpViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print(userInfo.json)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Set Up
  
  fileprivate func setUpViews() {
    let nameHeaderLabel = UILabel(frame: .zero)
    nameHeaderLabel.text = "Name"
    nameHeaderLabel.font = UIFont.systemFont(ofSize: 12)
    nameHeaderLabel.textColor = .turquoise
    
    nameHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameHeaderLabel)
    
    let nameHeaderTop = nameHeaderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
    let nameHeaderLeft = nameHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
    
    nameLabel.text = userInfo.name
    nameLabel.font = UIFont.systemFont(ofSize: 17)
    nameLabel.textColor = .black
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameLabel)
    
    let nameTop = nameLabel.topAnchor.constraint(equalTo: nameHeaderLabel.bottomAnchor, constant: 4)
    let nameLeft = nameLabel.leftAnchor.constraint(equalTo: nameHeaderLabel.leftAnchor)
    
    NSLayoutConstraint.activate([nameHeaderTop, nameHeaderLeft, nameTop, nameLeft])
  }
  
  //MARK: Helpers
  
  @objc fileprivate func handleCloseButton(_ button: UIBarButtonItem?) {
    dismiss(animated: true, completion: nil)
  }
  
}
