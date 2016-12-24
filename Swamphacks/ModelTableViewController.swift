//
//  ItemsViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

final class ModelTableViewController<Model>: UITableViewController {
  
  private var items: [Model] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private var reuseIdentifiers = Set<String>()
  
  let load: (([Model]) -> ()) -> ()
  
  let descriptor: (Model) -> CellDescriptor
  let didSelect: (Model) -> Void
  
  init(load: @escaping (([Model]) -> ()) -> (), descriptor: @escaping (Model) -> CellDescriptor, didSelect: @escaping (Model) -> Void) {
    self.load = load
    self.descriptor = descriptor
    self.didSelect = didSelect
    
    super.init(style: .plain)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    self.refreshControl = refreshControl
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    load { [weak self] items in
      self?.items = items
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let cellDescriptor = descriptor(item)
    
    if !reuseIdentifiers.contains(cellDescriptor.reuseIdentifier) {
      register(descriptor: cellDescriptor, in: tableView)
      reuseIdentifiers.insert(cellDescriptor.reuseIdentifier)
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor.reuseIdentifier, for: indexPath)
    cellDescriptor.configure(cell)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    didSelect(item)
  }
  
  fileprivate func register(descriptor: CellDescriptor, in tableView: UITableView) {
    switch descriptor.registerMode {
    case .withClass:
      tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
    case .withNib(let nib):
      tableView.register(nib, forCellReuseIdentifier: descriptor.reuseIdentifier)
    }
  }
  
  @objc fileprivate func refresh(sender: UIRefreshControl?) {
    load { [weak self] items in
      self?.items = items
      sender?.endRefreshing()
    }
  }
  
}
