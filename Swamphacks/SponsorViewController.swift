//
//  SponsorViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/8/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class SponsorViewController: UIViewController {
  let sponsor: Sponsor
  
  init(sponsor: Sponsor) {
    self.sponsor = sponsor
    super.init(nibName: String(describing: SponsorViewController.self), bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
