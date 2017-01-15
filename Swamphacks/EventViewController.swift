//
//  EventViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/31/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import HCSStarRatingView

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

struct ViewPair {
  let subview: UIView
  let superview: UIView
}

//TODO: Rating control and attendee counter. Right bar button to ScanVC if user is a volunteer?
final class EventViewController: UIViewController {
  fileprivate lazy var scanVC: ScanViewController = {
    let vc = ScanViewController()
    return vc
  }()
  
  fileprivate let event: Event
  
  //TODO: correct font for all of these labels. See their set up functions
  fileprivate let titleLabel: UILabel
  fileprivate let typeLabel: PaddedLabel
  fileprivate let descriptionLabel: UILabel
  fileprivate let dateLabel: UILabel
  fileprivate let locationLabel: UILabel
  fileprivate let mapImageView: UIImageView
  fileprivate let ratingView: HCSStarRatingView
  
  fileprivate static let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
  }()
  
  fileprivate static let hourMinuteFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma"
    formatter.amSymbol = "am"
    formatter.pmSymbol = "pm"
    return formatter
  }()
  
  init(event: Event) {
    self.event = event
    self.titleLabel = UILabel(frame: .zero)
    self.typeLabel = PaddedLabel(frame: .zero)
    self.descriptionLabel = UILabel(frame: .zero)
    self.dateLabel = UILabel(frame: .zero)
    self.locationLabel = UILabel(frame: .zero)
    self.mapImageView = UIImageView(frame: .zero)
    self.ratingView = HCSStarRatingView(frame: .zero)

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Event"
    setUpViews()
    
    scanVC.mode = .register(event)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "scan"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(openScanner(_:)))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
    
    typeLabel.layer.masksToBounds = true
    typeLabel.layer.cornerRadius = typeLabel.bounds.height/2
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: Set Up
  
  fileprivate func setUpViews() {
    setUpTypeLabel()
    setUpTitleLabel()
    setUpDescriptionLabel()
    setUpDateLabel()
    setUpLocationLabel()
    setUpMapImageView()
    setUpRatingView()
  }
  
  fileprivate func setUpTypeLabel() {
    typeLabel.text = event.type.capitalized
    typeLabel.textColor = .white
    typeLabel.font = UIFont.systemFont(ofSize: 14)

    typeLabel.backgroundColor = event.color
    
    setUp(subview: typeLabel, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 16)
      let right = viewPair.subview.rightAnchor.constraint(equalTo: viewPair.superview.rightAnchor, constant: -16)
      return [top, right]
    }
    
    typeLabel.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
  }
  
  fileprivate func setUpTitleLabel() {
    titleLabel.text = event.title
    titleLabel.textColor = .black
    titleLabel.adjustsFontSizeToFitWidth = true

    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
    
    setUp(subview: titleLabel, in: view) { viewPair in
      let centerY = viewPair.subview.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor, constant: 16)
      let right = viewPair.subview.rightAnchor.constraint(lessThanOrEqualTo: typeLabel.leftAnchor, constant: -8)
      return [centerY, left, right]
    }
  }
  
  fileprivate func setUpDescriptionLabel() {
    descriptionLabel.text = event.description
    descriptionLabel.textColor = .black
    
    descriptionLabel.font = typeLabel.font
    
    setUp(subview: descriptionLabel, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor, constant: 16)
      return [top, left]
    }
  }
  
  fileprivate func setUpDateLabel() {
    func addDateLabel() {
      setUp(subview: dateLabel, in: view) { viewPair in
        let top = viewPair.subview.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
        let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor, constant: 16)
        let right = viewPair.subview.rightAnchor.constraint(greaterThanOrEqualTo: typeLabel.rightAnchor)
        return [top, left, right]
      }
    }
    
    var dateString = EventViewController.dayFormatter.string(from: event.startTime)
    
    let calendar = NSCalendar(calendarIdentifier: .gregorian)!
    
    let day1 = Date(timeIntervalSince1970: 1484920800) // January 20, 2017 @ 9:00 am
    let day2 = Date(timeIntervalSince1970: 1485007200) // January 21, 2017 @ 9:00 am
    let day3 = Date(timeIntervalSince1970: 1485093600) // January 22, 2017 @ 9:00 am
    
    guard let day = [day1, day2, day3].filter({ calendar.isDate(event.startTime, inSameDayAs: $0) }).first else {
      print("ERROR: Event found that is not on Day 1, 2, or 3.")
      addDateLabel()
      return
    }
    
    let dayString: String
    
    switch day {
    case day1:
      dayString = "Day 1"
    case day2:
      dayString = "Day 2"
    case day3:
      dayString = "Day 3"
    default:
      dayString = ""
    }
    
    dateString += " | \(dayString)"
    
    let attributedDate = NSMutableAttributedString(string: dateString,
                                                  attributes: [NSForegroundColorAttributeName: UIColor.lightGray,
                                                               NSFontAttributeName: UIFont.systemFont(ofSize: 20)])
    
    let attributedTime = NSAttributedString(string: "\n\(EventViewController.hourMinuteFormatter.string(from: event.startTime))",
                                            attributes: [NSForegroundColorAttributeName: UIColor.black,
                                                         NSFontAttributeName: UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)])
    
    attributedDate.append(attributedTime)
    
    dateLabel.numberOfLines = 0
    dateLabel.attributedText = attributedDate
    
    addDateLabel()
  }
  
  fileprivate func setUpLocationLabel() {
    locationLabel.text = event.location
    locationLabel.textColor = .black
    locationLabel.font = UIFont.systemFont(ofSize: 20)
    locationLabel.adjustsFontSizeToFitWidth = true
    
    setUp(subview: locationLabel, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor, constant: 16)
      let right = viewPair.subview.rightAnchor.constraint(greaterThanOrEqualTo: typeLabel.rightAnchor)
      return [top, left, right]
    }
  }
  
  fileprivate func setUpMapImageView() {
    mapImageView.image = event.mapImage
    mapImageView.backgroundColor = .lightGray
    mapImageView.contentMode = .scaleAspectFit
    mapImageView.clipsToBounds = true
    
    setUp(subview: mapImageView, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: locationLabel.leftAnchor)
      let right = viewPair.subview.rightAnchor.constraint(equalTo: typeLabel.rightAnchor)
      let aspect = viewPair.subview.heightAnchor.constraint(equalTo: viewPair.subview.widthAnchor, multiplier: 9/16)
      return [top, left, right, aspect]
    }
  }
  
  fileprivate func setUpRatingView() {
    //TODO: set up rest of ratingView here
    ratingView.backgroundColor = .red
    
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(ratingView)
    
    setUp(subview: ratingView, in: view) { viewPair in
      let bottom = viewPair.subview.bottomAnchor.constraint(equalTo: viewPair.superview.bottomAnchor, constant: -16)
      let centerX = viewPair.subview.centerXAnchor.constraint(equalTo: viewPair.superview.centerXAnchor)
      let width = viewPair.subview.widthAnchor.constraint(equalToConstant: 200)
      let height = viewPair.subview.heightAnchor.constraint(equalToConstant: 100)
      return [bottom, centerX, width, height]
    }
  }
  
  //MARK: Actions
  
  @objc fileprivate func openScanner(_ sender: UIBarButtonItem) {
    let vc = scanVC.rooted().styled()
    present(vc, animated: true, completion: nil)
  }
  
  //MARK: Helpers
  
  fileprivate func setUp(subview: UIView, in superview: UIView, constraints: (ViewPair) -> [NSLayoutConstraint]) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    superview.addSubview(subview)
    NSLayoutConstraint.activate(constraints(ViewPair(subview: subview, superview: superview)))
  }
  
}
