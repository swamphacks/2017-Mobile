//
//  ProfileViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, ScanningDelegate {
  
  fileprivate lazy var scanVC: UIViewController = {
    let vc = ScanViewController()
    vc.scanningDelegate = self
    return vc.rooted().styled()
  }()
  
  @IBOutlet weak fileprivate var cameraButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func handleCameraButton(_ sender: AnyObject?) {
    show(scanVC, sender: self)
  }
  
  //MARK: ScanningDelegate
  
  func controller(vc: ScanViewController, didScan metadata: AVMetadataMachineReadableCodeObject) {
    print("SCANNED QR CODE: \(metadata.stringValue)")
  }
}
