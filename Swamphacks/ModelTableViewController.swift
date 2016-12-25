//
//  ItemsViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit

enum RowHeight {
  case absolute(CGFloat)
  case automatic
}

final class ModelTableViewController<Model>: UITableViewController {
  fileprivate var items: [Model] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private var reuseIdentifiers = Set<String>()
  
  let load: (([Model]) -> ()) -> ()
  
  let cellDescriptor: (Model) -> CellDescriptor
  let rowHeight: (Model, IndexPath) -> RowHeight
  let didSelect: (Model) -> Void
  
  init(style: UITableViewStyle = .plain,
       load: @escaping (([Model]) -> ()) -> (),
       cellDescriptor: @escaping (Model) -> CellDescriptor,
       rowHeight: @escaping (Model, IndexPath) -> RowHeight,
       didSelect: @escaping (Model) -> Void)
  {
    
    self.load = load
    
    self.cellDescriptor = cellDescriptor
    self.rowHeight = rowHeight
    self.didSelect = didSelect
    
    super.init(style: style)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    self.refreshControl = refreshControl
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: loading indicator? empty state?
    load { [weak self] items in
      self?.items = items
    }
  }
  
  //MARK: UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let descriptor = cellDescriptor(item)
    
    if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
      register(descriptor: descriptor, in: tableView)
      reuseIdentifiers.insert(descriptor.reuseIdentifier)
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
    descriptor.configure(cell)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item = items[indexPath.row]
    let height = rowHeight(item, indexPath)
    switch height {
    case .absolute(let h):
      return h
    case .automatic:
      return UITableViewAutomaticDimension
    }
  }
  
  //MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    didSelect(item)
  }
  
  //MARK: Actions
  
  @objc fileprivate func refresh(sender: UIRefreshControl?) {
    //TODO: loading indicator? empty state?
    load { [weak self] items in
      self?.items = items
      sender?.endRefreshing()
    }
  }
  
  //MARK: Helpers
  
  fileprivate func register(descriptor: CellDescriptor, in tableView: UITableView) {
    switch descriptor.registerMode {
    case .withClass:
      tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
    case .withNib(let nib):
      tableView.register(nib, forCellReuseIdentifier: descriptor.reuseIdentifier)
    }
  }
  
}
