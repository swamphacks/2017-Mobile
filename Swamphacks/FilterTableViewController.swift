//
//  FilterViewController.swift
//  Swamphacks
//
//  Created by Nikhil Thota on 1/15/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import Foundation
import UIKit

final class FilterTableViewController: UITableViewController, FilterCellDelegate {
  
  let types = ["logistics", "food", "sponsor", "social", "tech talk", "other"]
  fileprivate(set) var filters = ["logistics": true, "food": true, "sponsor": true, "social": true, "tech talk": true, "other": true]
  
  var dismissed: (Void) -> Void = { _ in }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: "FilterCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "filterCell")
    
    tableView.dataSource = self
    tableView.delegate = self
    
    let leftItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleCloseButton(_:)))
    navigationItem.leftBarButtonItem = leftItem
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return types.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterCell
    cell.filterLabel.text = types[indexPath.row].capitalized
    cell.filterSwitch.isOn = filters[types[indexPath.row]] ?? false
    cell.delegate = self
    return cell
  }
  
  func filterCell(_ filterCell: FilterCell, updatedSwitchTo value: Bool) {
    filters[filterCell.filterLabel.text!.lowercased()] = value
  }
  
  @objc fileprivate func handleCloseButton(_ item: UIBarButtonItem) {
    dismissed()
    dismiss(animated: true, completion: nil)
  }
    
}
