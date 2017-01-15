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
    
    self.timer?.invalidate()
    
    let timer = Timer(timeInterval: 1, repeats: true, block: updateCountdown)
    RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    
    self.timer = timer
  }
  
  fileprivate func updateCountdown(_: Timer) {
    var now = Date()
    let hackathonStart = Date(timeIntervalSince1970: 1484967600)
    let hackathonEnd = Date(timeIntervalSince1970: 1485097200)
    
    if (now.compare(hackathonStart) == .orderedAscending) {
      now = hackathonStart
    }
    
    let diff = hackathonEnd.timeIntervalSince(now)
    let totalDiff = hackathonEnd.timeIntervalSince(hackathonStart)
    
    let perc = CGFloat(diff)/CGFloat(totalDiff)
    progressView.setProgress(perc, animated: true)
    
    let components = CountdownView.calendar.components([.hour, .minute, .second], from: now, to: hackathonEnd, options: [])
    
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
