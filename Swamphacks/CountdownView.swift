//
//  CountdownView.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/28/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class CountdownView: UIView {
  
  fileprivate static let calendar = NSCalendar(calendarIdentifier: .gregorian)!
  fileprivate weak var timer: Timer?
  
  private(set) var baselineDate: Date?
  private(set) var event: Event?
  
  @IBOutlet weak private var progressView: CircularProgressView!
  @IBOutlet weak private var countdownLabel: UILabel!
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    setUp()
  }
  
  fileprivate func setUp() {
    progressView.padding = 16
    progressView.lineWidth = 32
    progressView.setProgress(0.85, animated: false)
  }
  
  func startTiming(for event: Event) {
    timer?.invalidate()
    
    let _timer = Timer(timeInterval: 1, repeats: true, block: updateCountdown)
    self.event = event
    baselineDate = Date()
    
    RunLoop.main.add(_timer, forMode: .defaultRunLoopMode)
    
    timer = _timer
  }
  
  fileprivate func updateCountdown(_: Timer) {
    guard let event = event, let baseline = baselineDate else { return }
    let start = Date()
    let end = event.startTime
    
    let diff = start.timeIntervalSince(baseline)
    let totalDiff = end.timeIntervalSince(baseline)
    
    //TODO: need to pick a good baseline for this percetange... Waiting on Takashi
    let perc = CGFloat(diff)/CGFloat(totalDiff)
    progressView.setProgress(perc, animated: true)
    
    let components = CountdownView.calendar.components([.hour, .minute, .second], from: start, to: end, options: [])
    
    countdownLabel.attributedText = attributedString(for: components)
    countdownLabel.textAlignment = .center
  }
  
  fileprivate func attributedString(for components: DateComponents) -> NSAttributedString? {
    guard let hour = components.hour, let minute = components.minute, let second = components.second else {
      return nil
    }
    
    func formatted(time: Int) -> String {
      return time < 10 ? "0\(time)" : "\(time)"
    }
    
    func attributesForSize(_ size: CGFloat, weight: CGFloat) -> [String: AnyObject] {
      return [NSForegroundColorAttributeName: UIColor.white,
              NSFontAttributeName: UIFont.systemFont(ofSize: size, weight: weight)]
    }
    
    let countdownText = NSMutableAttributedString(string: formatted(time: hour),
                                                  attributes: attributesForSize(40, weight: UIFontWeightBold))
    
    let hours = NSAttributedString(string: "\nhours",
                                   attributes: attributesForSize(22, weight: UIFontWeightRegular))
    
    let numMinSec = NSAttributedString(string: "\n\(formatted(time: minute)):\(formatted(time: second))",
                                       attributes: attributesForSize(28, weight: UIFontWeightBold))
    
    let minSec = NSAttributedString(string: "\nmm : ss",
                                    attributes: attributesForSize(22, weight: UIFontWeightRegular))
    
    countdownText.append(hours)
    countdownText.append(numMinSec)
    countdownText.append(minSec)
    
    return countdownText
  }
  
}
