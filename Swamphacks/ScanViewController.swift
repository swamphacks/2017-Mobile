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

protocol ScanningDelegate: class {
  func controller(vc: ScanViewController, didScan metadata: String?)
}

final class ScanViewController: UIViewController, VideoPreviewLayerProvider, MetadataOutputDelegate {

  fileprivate enum BarcodeMode {
    case showing(CGRect)
    case hidden
  }
  
  fileprivate let previewView: CapturePreviewView!
  
  //TODO: Customize detectorView? Just change border?
  fileprivate lazy var detectorView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.layer.borderWidth = 4
    return view
  }()
  
  public var detectorViewBorderColor: UIColor = .turquoise {
    didSet {
      detectorView.layer.borderColor = detectorViewBorderColor.cgColor
    }
  }
  
  weak var scanningDelegate: ScanningDelegate?
  
  fileprivate var detectorViewCenterX: NSLayoutConstraint!
  fileprivate var detectorViewCenterY: NSLayoutConstraint!
  fileprivate var detectorViewWidth: NSLayoutConstraint!
  fileprivate var detectorViewHeight: NSLayoutConstraint!
  
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
    captureManager.startRunning()
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
    view.addSubview(previewView)
    previewView.translatesAutoresizingMaskIntoConstraints = false
    
    let top     = previewView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
    let bottom  = previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    let left    = previewView.leftAnchor.constraint(equalTo: view.leftAnchor)
    let right   = previewView.rightAnchor.constraint(equalTo: view.rightAnchor)
    
    NSLayoutConstraint.activate([top, bottom, left, right])
    
    setUpDetectorView()
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
    
    reactToBarcode(.showing(barcode.bounds))
    scanningDelegate?.controller(vc: self, didScan: metadata.stringValue)
  }
  
  //MARK: Helpers
  
  @objc fileprivate func handleCloseButton(_ button: UIBarButtonItem?) {
    dismiss(animated: true, completion: nil)
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
