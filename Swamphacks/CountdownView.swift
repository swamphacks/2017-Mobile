//
//  CountdownView.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/28/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class CountdownView: UIView {
  
  @IBOutlet weak var progressView: CircularProgressView?
    
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    setUp()
  }
  
  fileprivate func setUp() {
    progressView?.padding = 16
    progressView?.lineWidth = 32
    progressView?.setProgress(0.85, animated: false)
  }
  
}
