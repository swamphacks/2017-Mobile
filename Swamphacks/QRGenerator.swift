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
  
  fileprivate static let context = CIContext(options: nil)
  
  fileprivate lazy var qrFilter: CIFilter? = {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue("H", forKey: "inputCorrectionLevel")
    return filter
  }()
  
  let metadata: String
  
  init(metadata: String) {
    self.metadata = metadata
  }
  
  func qrCode() -> UIImage? {
    let qrData = metadata.data(using: .utf8)
    
    guard let filter = qrFilter else { return nil }
    filter.setValue(qrData, forKey: "inputMessage")

    guard let output = filter.outputImage else { return nil }
    return image(from: output, scale: UIScreen.main.scale*2)
  }
  
  fileprivate func image(from ciImage: CIImage, scale: CGFloat) -> UIImage? {
    guard let cgImage = QRGenerator.context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    let renderer = UIGraphicsImageRenderer(size: ciImage.extent.size.scaled(by: scale))
    return renderer.image { ctx in
      ctx.cgContext.interpolationQuality = .none
      ctx.cgContext.draw(cgImage, in: ctx.cgContext.boundingBoxOfClipPath)
    }
  }
  
}

public protocol Scalable {
  associatedtype DataType
  mutating func scale(by factor: DataType)
  func scaled(by factor: DataType) -> Self
}

extension CGSize: Scalable {
  public typealias DataType = CGFloat
  
  public mutating func scale(by factor: DataType) {
    width = width*factor
    height = height*factor
  }
  
  public func scaled(by factor: DataType) -> CGSize {
    var copy = self
    copy.scale(by: factor)
    return copy
  }
}
