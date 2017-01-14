//
//  ScanViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/29/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

import AVFoundation
import GNCam

import Firebase
import MMMaterialDesignSpinner

protocol ScanningDelegate: class {
  func controller(vc: ScanViewController, didScan metadata: String?)
}

enum ScanMode {
  case confirm
  case register(Event)
}

final class ScanViewController: UIViewController, VideoPreviewLayerProvider, MetadataOutputDelegate {

  fileprivate enum BarcodeMode {
    case showing(CGRect)
    case hidden
  }
  
  fileprivate let previewView: CapturePreviewView!
  
  fileprivate lazy var detectorView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.layer.borderWidth = 4
    return view
  }()
  
  fileprivate lazy var spinner: MMMaterialDesignSpinner = {
    let spinner = MMMaterialDesignSpinner(frame: .zero)
    spinner.backgroundColor = .turquoise
    spinner.tintColor = .white
    spinner.lineWidth = 4
    spinner.hidesWhenStopped = true
    spinner.layer.cornerRadius = 8
    spinner.layer.masksToBounds = true
    return spinner
  }()
  
  var detectorViewBorderColor: UIColor = .turquoise {
    didSet {
      detectorView.layer.borderColor = detectorViewBorderColor.cgColor
    }
  }
  
  var mode: ScanMode = .confirm
  
  weak var scanningDelegate: ScanningDelegate?
  
  fileprivate var detectorViewCenterX: NSLayoutConstraint!
  fileprivate var detectorViewCenterY: NSLayoutConstraint!
  fileprivate var detectorViewWidth: NSLayoutConstraint!
  fileprivate var detectorViewHeight: NSLayoutConstraint!
  
  fileprivate var shouldScan = false
  
  fileprivate var isLoading: Bool {
    return spinner.isAnimating
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    previewView = CapturePreviewView(frame: .zero)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    title = "Scan"
    setUp()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
      self?.shouldScan = true
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    shouldScan = false
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    captureManager.stopRunning()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Set Up
  
  fileprivate func setUp() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(handleCloseButton(_:)))
    setUpViews()
    setUpCaptureManager()
  }
  
  fileprivate func setUpViews() {
    previewView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(previewView)
    
    let top     = previewView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
    let bottom  = previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    let left    = previewView.leftAnchor.constraint(equalTo: view.leftAnchor)
    let right   = previewView.rightAnchor.constraint(equalTo: view.rightAnchor)
    
    NSLayoutConstraint.activate([top, bottom, left, right])
    
    setUpDetectorView()
    
    spinner.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
    navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: spinner)
  }
  
  fileprivate func setUpDetectorView() {
    detectorView.layer.borderColor = detectorViewBorderColor.cgColor
    detectorView.alpha = 0
    
    detectorView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(detectorView)
    
    detectorViewCenterX = detectorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    detectorViewCenterY = detectorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    detectorViewWidth = detectorView.widthAnchor.constraint(equalToConstant: 44)
    detectorViewHeight = detectorView.heightAnchor.constraint(equalToConstant: 44)
    
    NSLayoutConstraint.activate([detectorViewCenterX, detectorViewCenterY, detectorViewWidth, detectorViewHeight])
  }
  
  fileprivate func setUpCaptureManager() {
    captureManager.setUp(sessionPreset: AVCaptureSessionPresetHigh,
                         previewLayerProvider: self,
                         inputs: [.video],
                         outputs: [.metadata([AVMetadataObjectTypeQRCode])])
    { (error) in
      print("Woops, got error: \(error)")
    }
    
    captureManager.metadataOutputDelegate = self
    captureManager.startRunning()
  }
  
  //MARK: VideoPreviewLayerProvider
  
  var previewLayer: AVCaptureVideoPreviewLayer {
    return previewView.layer as! AVCaptureVideoPreviewLayer
  }
  
  //MARK: MetadataOutputDelegate
  
  public func captureManagerDidOutput(metadataObjects: [Any]) {
    if metadataObjects.isEmpty {
      reactToBarcode(.hidden)
      return
    }
    
    guard let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, metadata.type == AVMetadataObjectTypeQRCode,
      let barcode = previewLayer.transformedMetadataObject(for: metadata) else { return }
    
    if (!shouldScan) {
      reactToBarcode(.hidden)
      return
    }
    
    reactToBarcode(.showing(barcode.bounds))
    
    scanningDelegate?.controller(vc: self, didScan: metadata.stringValue)
    
    // ***************************
    // Just slapped this in here. Sorry not sorry, again lolz. Deadlines are great 🙃
    
    switch mode {
    case .confirm:
      confirmUserInfo(metadata: metadata.stringValue)
    case .register(let event):
      register(for: event, metadata: metadata.stringValue)
    }
  }
  
  //MARK: Helpers
  
  fileprivate func confirmUserInfo(metadata: String?) {
    if (isLoading) {
      return
    }
    
    guard let email = metadata, !email.isEmpty else {
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
  
  fileprivate func register(for event: Event, metadata: String?) {
    guard let email = FIRAuth.auth()?.currentUser?.email, let title = metadata, !title.isEmpty else {
      return
    }
    
    let emailKey = email.replacingOccurrences(of: "@", with: "").replacingOccurrences(of: ".", with: "")
    let scannedTitle = title.replacingOccurrences(of: " ", with: "")
    let ogTitle = event.title.replacingOccurrences(of: " ", with: "")
    
    if ogTitle.caseInsensitiveCompare(scannedTitle) == .orderedSame {
      let classification = event.classification
      
      let path = "attendee_events/\(emailKey)/\(event.title)"
      let ref = FIRDatabase.database().reference(withPath: path)
      
      ref.setValue(classification)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  @objc fileprivate func handleCloseButton(_ button: UIBarButtonItem?) {
    dismiss(animated: true, completion: nil)
  }
  
  fileprivate func setLoading(_ loading: Bool) {
    spinner.setAnimating(loading)
  }
  
  fileprivate func reactToBarcode(_ mode: BarcodeMode) {
    switch mode {
    case .showing(let bounds):
      detectorViewCenterX.constant = bounds.midX - view.center.x
      detectorViewCenterY.constant = bounds.midY + 64 - view.center.y
      detectorViewWidth.constant   = bounds.width
      detectorViewHeight.constant  = bounds.height
      
      view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.2) {
        self.detectorView.alpha = 1
      }
    case .hidden:
      UIView.animate(withDuration: 0.2) {
        self.detectorView.alpha = 0
      }
    }
  }
  
}
