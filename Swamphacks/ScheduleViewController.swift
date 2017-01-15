//
//  ScheduleViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/2/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit

import MMMaterialDesignSpinner

class ScheduleViewController: UICollectionViewController, CalendarLayoutDelegate {
  
  fileprivate lazy var spinner: MMMaterialDesignSpinner = {
    let spinner = MMMaterialDesignSpinner(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    spinner.tintColor = .white
    spinner.lineWidth = 4
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  fileprivate var eventOrganizer = EventOrganizer(events: [])
  
  fileprivate(set) var events: [Event] = []
  
  fileprivate var calendarLayout: CalendarLayout {
    return collectionView?.collectionViewLayout as! CalendarLayout
  }
  
  let load: (@escaping ([Event]) -> ()) -> ()
  
  init(events: @escaping (@escaping ([Event]) -> ()) -> ()) {
    self.load = events
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: spinner)
    setUp()
    loadEvents()
  }
  
  override func loadView() {
    let layout = CalendarLayout()
    layout.rowInsets = UIEdgeInsets(top: 0.0, left: 62.0, bottom: 0.0, right: 0.0)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
      transitionCoordinator?.animate(alongsideTransition: { context in
        self.collectionView?.deselectItem(at: indexPath, animated: animated)
      }, completion: { context in
        if context.isCancelled {
          self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
      })
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  fileprivate func setUp() {
    setUpCollectionView()
  }
  
  fileprivate func setUpCollectionView() {
    collectionView?.register(UINib(nibName: "ScheduleEventCell", bundle: nil),
                             forCellWithReuseIdentifier: "EventCell")
    
    collectionView?.register(UINib(nibName: "ScheduleDayHeader", bundle: nil),
                             forSupplementaryViewOfKind: CalendarLayout.SupplementaryViewKind.Header.rawValue,
                             withReuseIdentifier: "DayHeader")
    
    collectionView?.register(UINib(nibName: "ScheduleHourSeparator", bundle: nil),
                             forSupplementaryViewOfKind: CalendarLayout.SupplementaryViewKind.Separator.rawValue,
                             withReuseIdentifier: "HourSeparator")
    
    collectionView?.register(UINib(nibName: "ScheduleNowIndicator", bundle: nil),
                             forSupplementaryViewOfKind: CalendarLayout.SupplementaryViewKind.NowIndicator.rawValue,
                             withReuseIdentifier: "NowIndicator")
    
    collectionView?.register(UINib(nibName: "ScheduleNowLabel", bundle: nil),
                             forSupplementaryViewOfKind: CalendarLayout.SupplementaryViewKind.NowLabel.rawValue,
                             withReuseIdentifier: "NowLabel")
  }
  
  //MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return eventOrganizer.days.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return eventOrganizer.numberOfEventsInDay(section)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! ScheduleEventCell
    
    let event = eventOrganizer.eventAtIndex((indexPath as NSIndexPath).item, inDay: (indexPath as NSIndexPath).section)
    cell.color = event.color
    cell.textLabel.text = event.title
    cell.detailTextLabel.text = event.location
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch CalendarLayout.SupplementaryViewKind(rawValue: kind)! {
    case .Header:
      let dayHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DayHeader", for: indexPath) as! ScheduleDayHeader
      dayHeader.textLabel.text = eventOrganizer.days[(indexPath as NSIndexPath).section].weekdayTitle
      dayHeader.detailTextLabel.text = eventOrganizer.days[(indexPath as NSIndexPath).section].dateTitle
      return dayHeader
      
    case .Separator:
      let hourSeparator = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HourSeparator", for: indexPath) as! ScheduleHourSeparator
      hourSeparator.label.text = eventOrganizer.days[(indexPath as NSIndexPath).section].hours[(indexPath as NSIndexPath).item].title
      return hourSeparator
      
    case .NowIndicator:
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NowIndicator", for: indexPath) as! ScheduleNowIndicator
      
    case .NowLabel:
      let nowLabel = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NowLabel", for: indexPath) as! ScheduleNowLabel
      nowLabel.label.text = Hour.minuteFormatter.string(from: Date())
      return nowLabel
    }
  }
  
  // MARK: CalendarLayoutDelegate
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, numberOfRowsInSection section: Int) -> Int {
    return eventOrganizer.days[section].hours.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, startRowForItemAtIndexPath indexPath: IndexPath) -> Double {
    return eventOrganizer.partialHoursForEventAtIndex((indexPath as NSIndexPath).item, inDay: (indexPath as NSIndexPath).section).lowerBound
  }
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, endRowForItemAtIndexPath indexPath: IndexPath) -> Double {
    return eventOrganizer.partialHoursForEventAtIndex((indexPath as NSIndexPath).item, inDay: (indexPath as NSIndexPath).section).upperBound
  }
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, numberOfColumnsForItemAtIndexPath indexPath: IndexPath) -> Int {
    return eventOrganizer.numberOfColumnsForEventAtIndex((indexPath as NSIndexPath).item, inDay: (indexPath as NSIndexPath).section)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, columnForItemAtIndexPath indexPath: IndexPath) -> Int {
    return eventOrganizer.columnForEventAtIndex((indexPath as NSIndexPath).item, inDay: (indexPath as NSIndexPath).section)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    showDetailsForEvent(eventOrganizer.eventAtIndex((indexPath as NSIndexPath).row, inDay: (indexPath as NSIndexPath).section))
  }
  
  //MARK: Navigation
  
  func showDetailsForEvent(_ event: Event) {
    let eventViewController = EventViewController(event: event)
    show(eventViewController, sender: self)
  }
  
  //MARK: Helpers
  
  fileprivate var loadTimer: Timer?
  
  fileprivate func loadEvents() {
    setLoading(true)
    load { [weak self] events in
      guard let strongSelf = self else { return }
      strongSelf.events.append(contentsOf: events)
      
      strongSelf.loadTimer?.invalidate()
      
      strongSelf.loadTimer = Timer(timeInterval: 5, repeats: false) { timer in
        self?.setLoading(false)
        self?.eventOrganizer = EventOrganizer(events: strongSelf.events)
        self?.collectionView?.reloadData()
      }
      
      RunLoop.main.add(strongSelf.loadTimer!, forMode: .defaultRunLoopMode)
    }
  }
  
  fileprivate func setLoading(_ loading: Bool) {
    spinner.setAnimating(loading)
  }
  
}
