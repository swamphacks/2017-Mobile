//
//  CircularProgressView.swift
//  Post
//
//  Created by Gonzalo Nunez on 3/1/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
  
  static fileprivate let kRingProgressAnimationKey = "strokeEnd"
  
  var lineWidth: CGFloat = 4 {
    didSet {
      setUpRing()
    }
  }
  
  var lineColor: UIColor = UIColor.white {
    didSet {
      setUpRing()
    }
  }
  
  var padding: CGFloat = 3 {
    didSet {
      setUpRing()
    }
  }
  
  var animationDuration = 0.15
  
  fileprivate let ringLayer = CAShapeLayer()
  fileprivate var progress:CGFloat = 0.8
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let ringPath = setRingPath()
    ringLayer.bounds = ringPath.boundingBox
    ringLayer.position = layer.bounds.mid
  }
  
  fileprivate func setUp() {
    setUpRing()
  }
  
  fileprivate func setUpRing() {
    ringLayer.removeFromSuperlayer()
    
    _ = setRingPath()
    
    ringLayer.fillColor = UIColor.clear.cgColor
    ringLayer.strokeColor = lineColor.cgColor
    
    ringLayer.lineCap = kCALineCapRound
    ringLayer.lineWidth = lineWidth
    ringLayer.strokeEnd = progress
    
    layer.addSublayer(ringLayer)
  }
  
  func setProgress(_ prog: CGFloat, animated: Bool) {
    progress = prog
    
    let fillAnimation = CABasicAnimation(keyPath: CircularProgressView.kRingProgressAnimationKey)
    fillAnimation.duration = animated ? animationDuration : 0
    fillAnimation.fromValue = ringLayer.strokeEnd
    fillAnimation.toValue = progress
    fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    ringLayer.strokeEnd = progress
    ringLayer.add(fillAnimation, forKey: CircularProgressView.kRingProgressAnimationKey)
  }
  
  //MARK - Helpers
  
  fileprivate func setRingPath() -> CGMutablePath {
    let rect = layer.bounds
    let path = ringPath(in: rect)
    ringLayer.path = path
    return path
  }
  
  fileprivate func ringPath(in rect: CGRect) -> CGMutablePath {
    let outerRadius = radius(in: rect)
    let centerX = rect.midX
    let centerY = rect.midY
    
    let ringPath = CGMutablePath()
    ringPath.addArc(center: CGPoint(x: centerX, y: centerY),
                    radius: outerRadius,
                    startAngle: -CGFloat.pi/2, endAngle:  3*CGFloat.pi/2,
                    clockwise: false)
    
    return ringPath
  }
  
  fileprivate func radius(in rect: CGRect) -> CGFloat {
    return min(rect.width, rect.height)/2 - (padding*2)
  }
  
}

extension CGRect {
  
  var mid: CGPoint {
     return CGPoint(x: midX, y: midY)
  }
  
}
