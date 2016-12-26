//
//  HappeningNowViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class HappeningNowViewController: UIViewController {
  
  @IBOutlet weak fileprivate var progressView: CircularProgressView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: add the table view down here and get the most recent event. Wait for a reponse in the Slack w/ regards to the date...
    progressView.padding = 16
    progressView.lineWidth = 32
    progressView.setProgress(0.85, animated: false)
    
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }


}

