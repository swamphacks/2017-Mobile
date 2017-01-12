//
//  QRGenerator.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/11/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit
import CoreImage

final class QRGenerator {
  
  fileprivate lazy var qrFilter: CIFilter? = {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue("H", forKey: "inputCorrectionLevel")
    return filter
  }()
  
  let metadata: String
  
  init(metadata: String) {
    self.metadata = metadata
  }
  
  /*
  func generate() -> UIImage? {
    let qrData = metadata.data(using: .utf8)
    
    guard let filter = qrFilter else { return nil }
    filter.setValue(qrData, forKey: "inputMessage")

    let output = filter.outputImage
    
    
  }
  */
  
}
