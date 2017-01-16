//
//  EventViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/31/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Firebase

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
  fileprivate let event: Event
  
  //TODO: correct font for all of these labels. See their set up functions
  fileprivate let titleLabel: UILabel
  fileprivate let typeLabel: PaddedLabel
  fileprivate let descriptionLabel: UILabel
  fileprivate let dateLabel: UILabel
  fileprivate let locationLabel: UILabel
  fileprivate let mapImageView: UIImageView
  
  fileprivate let ratingView: HCSStarRatingView
  fileprivate let ratingsPromptLabel: UILabel
  
  fileprivate let attendeeCountLabel: UILabel
  fileprivate let attendeeCountHeaderLabel: UILabel
  fileprivate let upButton: UIButton
  fileprivate let downButton: UIButton
  
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
  
  fileprivate var attendeeCount = 0
  
  init(event: Event) {
    self.event = event
    self.titleLabel = UILabel(frame: .zero)
    self.typeLabel = PaddedLabel(frame: .zero)
    self.descriptionLabel = UILabel(frame: .zero)
    self.dateLabel = UILabel(frame: .zero)
    self.locationLabel = UILabel(frame: .zero)
    self.mapImageView = UIImageView(frame: .zero)
    
    self.ratingView = HCSStarRatingView(frame: .zero)
    self.ratingsPromptLabel = UILabel(frame: .zero)
    
    self.attendeeCountLabel = UILabel(frame: .zero)
    self.attendeeCountHeaderLabel = UILabel(frame: .zero)
    self.upButton = UIButton(frame: .zero)
    self.downButton = UIButton(frame: .zero)
    
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
    
    view.bringSubview(toFront: ratingView)
    
    if let user = FIRAuth.auth()?.currentUser {
      user.getInfo() { info in
        let isVolunteer = info?.isVolunteer ?? false
        
        self.ratingView.isHidden = isVolunteer
        self.ratingsPromptLabel.isHidden = isVolunteer
        
        self.attendeeCountLabel.isHidden = !isVolunteer
        self.attendeeCountHeaderLabel.isHidden = !isVolunteer
        self.upButton.isHidden = !isVolunteer
        self.downButton.isHidden = !isVolunteer
      }
    } else {
      ratingView.isHidden = false
      ratingsPromptLabel.isHidden = false
      
      attendeeCountLabel.isHidden = true
      attendeeCountHeaderLabel.isHidden = true
      upButton.isHidden = true
      downButton.isHidden = true
    }
    
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    pushRatingOrCounter()
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
    setUpCounterViews()
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
    descriptionLabel.numberOfLines = 0
    
    setUp(subview: descriptionLabel, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor, constant: 16)
      let right = viewPair.subview.rightAnchor.constraint(lessThanOrEqualTo: typeLabel.rightAnchor)
      return [top, left, right]
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
    locationLabel.font = UIFont.systemFont(ofSize: 17)
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
    mapImageView.contentMode = .scaleAspectFit
    mapImageView.clipsToBounds = true
    
    setUp(subview: mapImageView, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: locationLabel.leftAnchor)
      let right = viewPair.subview.rightAnchor.constraint(equalTo: typeLabel.rightAnchor)
      let aspect = viewPair.subview.heightAnchor.constraint(equalTo: viewPair.subview.widthAnchor, multiplier: 12/13 * 0.7)
      return [top, left, right, aspect]
    }
  }
  
  fileprivate func setUpRatingView() {
    ratingView.backgroundColor = .clear
    ratingView.allowsHalfStars = true
    ratingView.emptyStarImage = UIImage(named: "star-empty")
    ratingView.halfStarImage = UIImage(named: "star-half")
    ratingView.filledStarImage = UIImage(named: "star-full")
    
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(ratingView)
    
    setUp(subview: ratingView, in: view) { viewPair in
      let bottom = viewPair.subview.bottomAnchor.constraint(equalTo: viewPair.superview.bottomAnchor, constant: -8)
      let centerX = viewPair.subview.centerXAnchor.constraint(equalTo: viewPair.superview.centerXAnchor)
      let width = viewPair.subview.widthAnchor.constraint(equalToConstant: 260)
      let height = viewPair.subview.heightAnchor.constraint(equalToConstant: 50)
      return [bottom, centerX, width, height]
    }
    
    ratingsPromptLabel.text = "How was your experience?"
    ratingsPromptLabel.font = UIFont.systemFont(ofSize: 14)
    
    setUp(subview: ratingsPromptLabel, in: view) { viewPair -> [NSLayoutConstraint] in
      let bottom = viewPair.subview.bottomAnchor.constraint(equalTo: ratingView.topAnchor, constant: -4)
      let centerX = viewPair.subview.centerXAnchor.constraint(equalTo: viewPair.superview.centerXAnchor)
      return [bottom, centerX]
    }
  }
  
  fileprivate func setUpCounterViews() {
    let container = UIView(frame: .zero)
    container.backgroundColor = .clear
    container.alpha = 0
    
    setUp(subview: container, in: view) { viewPair in
      let top = viewPair.subview.topAnchor.constraint(equalTo: mapImageView.bottomAnchor, constant: 8)
      let bottom = viewPair.subview.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
      let left = viewPair.subview.leftAnchor.constraint(equalTo: viewPair.superview.leftAnchor)
      let right = viewPair.subview.rightAnchor.constraint(equalTo: viewPair.superview.rightAnchor)
      return [top, bottom, left, right]
    }
    
    attendeeCountLabel.text = "0"
    attendeeCountLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFontWeightBold)
    
    setUp(subview: attendeeCountLabel, in: view) { viewPair in
      let centerY = viewPair.subview.centerYAnchor.constraint(equalTo: container.centerYAnchor)
      let centerX = viewPair.subview.centerXAnchor.constraint(equalTo: container.centerXAnchor)
      return [centerX, centerY]
    }
    
    attendeeCountHeaderLabel.text = "Attendees Count"
    attendeeCountHeaderLabel.font = UIFont.systemFont(ofSize: 14)
    
    setUp(subview: attendeeCountHeaderLabel, in: view) { viewPair in
      let bottom = viewPair.subview.bottomAnchor.constraint(equalTo: attendeeCountLabel.topAnchor, constant: -4)
      let centerX = viewPair.subview.centerXAnchor.constraint(equalTo: container.centerXAnchor)
      return [bottom, centerX]
    }
    
    upButton.layer.cornerRadius = 8
    upButton.layer.masksToBounds = true
    upButton.backgroundColor = UIColor(red: 192/255, green: 244/255, blue: 184/255, alpha: 1)
    upButton.setImage(UIImage(named: "add"), for: .normal)
    upButton.addTarget(self, action: #selector(handleUpvote(_:)), for: .touchUpInside)
    
    setUp(subview: upButton, in: view) { viewPair in
      let left = viewPair.subview.leftAnchor.constraint(equalTo: attendeeCountLabel.rightAnchor, constant: 32)
      let centerY = viewPair.subview.centerYAnchor.constraint(equalTo: attendeeCountLabel.centerYAnchor)
      let height = viewPair.subview.heightAnchor.constraint(equalToConstant: 38)
      let width = viewPair.subview.widthAnchor.constraint(equalToConstant: 74)
      return [left, centerY, height, width]
    }
    
    downButton.layer.cornerRadius = 8
    downButton.layer.masksToBounds = true
    downButton.backgroundColor = UIColor(red: 249/255, green: 167/255, blue: 167/255, alpha: 1)
    downButton.setImage(UIImage(named: "remove"), for: .normal)
    downButton.addTarget(self, action: #selector(handleDownvote(_:)), for: .touchUpInside)
    
    setUp(subview: downButton, in: view) { viewPair in
      let right = viewPair.subview.rightAnchor.constraint(equalTo: attendeeCountLabel.leftAnchor, constant: -32)
      let centerY = viewPair.subview.centerYAnchor.constraint(equalTo: attendeeCountLabel.centerYAnchor)
      let height = viewPair.subview.heightAnchor.constraint(equalToConstant: 38)
      let width = viewPair.subview.widthAnchor.constraint(equalToConstant: 74)
      return [right, centerY, height, width]
    }
  }
  
  @objc fileprivate func handleUpvote(_ sender: UIButton) {
    attendeeCount += 1
    attendeeCountLabel.text = "\(attendeeCount)"
  }
  
  @objc fileprivate func handleDownvote(_ sender: UIButton) {
    if attendeeCount > 0 {
      attendeeCount -= 1
      attendeeCountLabel.text = "\(attendeeCount)"
    }
  }
  
  fileprivate func pushRatingOrCounter() {
    guard let user = FIRAuth.auth()?.currentUser, let email = user.email else { return }
    let emailKey = email.replacingOccurrences(of: "@", with: "").replacingOccurrences(of: ".", with: "")
    
    user.getInfo() { info in
      guard let userInfo = info else { return }
      if userInfo.isVolunteer {
        
        let path = "event_stats/\(self.event.title)/attendeeNum/\(emailKey)"
        let ref = FIRDatabase.database().reference(withPath: path)
        
        ref.setValue(self.attendeeCount)
        
      } else {
        
        let rating = self.ratingView.value
        
        let path = "event_stats/\(self.event.title)/ratings/\(emailKey)"
        let ref = FIRDatabase.database().reference(withPath: path)
        
        ref.setValue(rating)
      }
    }
  }
  
  //MARK: Actions
  
  @objc fileprivate func openScanner(_ sender: UIBarButtonItem) {
    app.scanVC.mode = .register(event)
    app.scanVC.shouldScan = true
    let vc = app.scanVC.rooted().styled()
    present(vc, animated: true, completion: nil)
  }
  
  //MARK: Helpers
  
  fileprivate func setUp(subview: UIView, in superview: UIView, constraints: (ViewPair) -> [NSLayoutConstraint]) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    superview.addSubview(subview)
    NSLayoutConstraint.activate(constraints(ViewPair(subview: subview, superview: superview)))
  }
  
}
