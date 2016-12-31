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

class ModelTableViewController<Model>: UITableViewController {
  fileprivate(set) var items: [Model] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  fileprivate var reuseIdentifiers = Set<String>()
  
  var isIncremental: Bool
  
  var refreshable: Bool = true {
    didSet {
      if !refreshable {
        refreshControl = nil
        return
      }
      addRefreshControl()
    }
  }
  
  fileprivate func addRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    self.refreshControl = refreshControl
  }
  
  let load: (@escaping ([Model]) -> ()) -> ()
  
  let cellDescriptor: (Model) -> CellDescriptor
  let rowHeight: (Model, IndexPath) -> RowHeight
  
  var header: (Int) -> (RowHeight, UIView?) = { _ in (.automatic, nil) }
  var didSelect: (Model) -> Void = { _ in }
  
  init(style: UITableViewStyle = .plain,
       isIncremental: Bool = false, // Do we replace the array each time or simply append to it? This only exists bc Firebase.
       load: @escaping (@escaping ([Model]) -> ()) -> (),
       cellDescriptor: @escaping (Model) -> CellDescriptor,
       rowHeight: @escaping (Model, IndexPath) -> RowHeight)
  {
    self.isIncremental = isIncremental
    self.load = load
    
    self.cellDescriptor = cellDescriptor
    self.rowHeight = rowHeight
    
    super.init(style: style)
    
    addRefreshControl()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: loading indicator? empty state?
    load { [weak self] items in
      self?.reload(items: items)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateHeaderViewIfNeeded()
  }
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
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
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let height = header(section).0
    switch height {
    case .absolute(let h):
      return h
    case .automatic:
      return UITableViewAutomaticDimension
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return header(section).1
  }
  
  //MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    didSelect(item)
  }
  
  //MARK: UIScrollViewDelegate
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateHeaderViewIfNeeded()
  }
  
  //MARK: Actions
  
  @objc fileprivate func refresh(sender: UIRefreshControl?) {
    items.removeAll()
    load { [weak self] items in
      sender?.endRefreshing()
      self?.reload(items: items)
    }
  }
  
  //MARK: Sticky Header
  
  fileprivate var _stickyHeader: UIView?
  fileprivate var headerHeight: Height = 0
  fileprivate var headerWidth: Width = 0
  
  typealias Height = CGFloat
  typealias Width = CGFloat
  
  var stickyHeader: (UIView, Height, Width)? {
    didSet {
      guard let (view, height, width) = stickyHeader else {
        _stickyHeader?.removeFromSuperview()
        _stickyHeader = nil
        
        headerHeight = 0
        headerWidth = 0
        
        tableView.contentInset = .zero
        tableView.contentOffset = .zero
        return
      }
      
      _stickyHeader = view
      headerHeight = height
      headerWidth = width
      
      view.frame = CGRect(x: 0, y: -headerHeight, width: headerWidth, height: headerHeight)
      tableView.addSubview(view)

      tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
      tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
      
      updateHeaderViewIfNeeded()
    }
  }
  
  fileprivate func updateHeaderViewIfNeeded() {
    guard let tableView = tableView, let headerView = _stickyHeader else { return }
    var rect = CGRect(x: 0, y: -headerHeight, width: headerWidth, height: headerHeight)
    if tableView.contentOffset.y < -headerHeight {
      rect = CGRect(x: 0, y: tableView.contentOffset.y, width: headerWidth, height: -tableView.contentOffset.y)
    }
    headerView.frame = rect
  }
  
  //MARK: Helpers
  
  fileprivate func reload(items: [Model]) {
    if isIncremental {
      self.items.append(contentsOf: items)
    } else {
      self.items = items
    }
  }
  
  fileprivate func register(descriptor: CellDescriptor, in tableView: UITableView) {
    switch descriptor.registerMode {
    case .withClass:
      tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
    case .withNib(let nib):
      tableView.register(nib, forCellReuseIdentifier: descriptor.reuseIdentifier)
    }
  }
  
}
