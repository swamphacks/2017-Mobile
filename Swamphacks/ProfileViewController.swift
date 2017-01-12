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

//TODO: Toggle view based on volunteer vs hacker. Make QRCode for hackers and cache locally. Finish layout.

class ProfileViewController: UIViewController, ScanningDelegate {
  fileprivate lazy var scanVC: UIViewController = {
    let vc = ScanViewController()
    vc.scanningDelegate = self
    return vc.rooted().styled()
  }()
  
  //TODO: Make button bigger like the designs or ask for it to be smaller?
  @IBOutlet weak fileprivate var cameraButton: UIButton!
  
  @IBOutlet weak fileprivate var displayNameLabel: UILabel!
  @IBOutlet weak fileprivate var emailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    displayNameLabel.text = nil
    emailLabel.text = nil
    
    if let user = FIRAuth.auth()?.currentUser {
      user.getInfo(completion: { userInfo in
        self.displayNameLabel.text = userInfo?.name
        self.emailLabel.text = userInfo?.email        
      })
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func handleCameraButton(_ sender: AnyObject?) {
    show(scanVC, sender: self)
  }
  
  //MARK: ScanningDelegate
  
  //TODO: Handle what happens when we did scan. We might move some of this logic to ScanVC.
  func controller(vc: ScanViewController, didScan metadata: String?) {
    print("SCANNED QR CODE: \(metadata!)")
  }
}
