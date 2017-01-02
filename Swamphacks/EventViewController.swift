//
//  EventViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/31/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class PaddedLabel: UILabel {
  var padding = UIEdgeInsets.zero {
    didSet {
      sizeToFit()
    }
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
  }
  
  override var intrinsicContentSize: CGSize {
    let superContentSize = super.intrinsicContentSize
    let width = superContentSize.width + padding.left + padding.right
    let heigth = superContentSize.height + padding.top + padding.bottom
    return CGSize(width: width, height: heigth)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let superSizeThatFits = super.sizeThatFits(size)
    let width = superSizeThatFits.width + padding.left + padding.right
    let heigth = superSizeThatFits.height + padding.top + padding.bottom
    return CGSize(width: width, height: heigth)
  }
}

final class EventViewController: UIViewController {
  fileprivate let event: Event
  fileprivate let typeLabel: PaddedLabel
  
  init(event: Event) {
    self.typeLabel = PaddedLabel(frame: .zero)
    self.event = event
    super.init(nibName: String(describing: EventViewController.self), bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = event.title
    setUpViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  fileprivate func setUpViews() {
    typeLabel.text = event.type
    typeLabel.backgroundColor = .turquoise
    
    typeLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(typeLabel)
    
    let top = typeLabel.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 16)
    let right = typeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
    NSLayoutConstraint.activate([top, right])
    
    typeLabel.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  }
  
}
