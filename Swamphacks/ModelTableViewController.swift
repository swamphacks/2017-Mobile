//
//  ItemsViewController.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import MMMaterialDesignSpinner

enum RowHeight {
  case absolute(CGFloat)
  case automatic
}

enum Header {
  case title(String)
  case view(UIView)
}

class ModelTableViewController<Model>: UITableViewController {
  fileprivate(set) var items: [Model] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  fileprivate var filteredItems: [Model] {
    return filter(items)
  }
  
  var filter: (([Model]) -> [Model]) = { $0 } {
    didSet {
      localReload()
    }
  }
  
  func localReload() {
    tableView.reloadData()
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
  
  fileprivate lazy var spinner: MMMaterialDesignSpinner = {
    let spinner = MMMaterialDesignSpinner(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    spinner.tintColor = .white
    spinner.lineWidth = 4
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  var showsIndicator: Bool = true {
    didSet {
      if (showsIndicator) {
        navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: spinner)
      } else {
        navigationItem.rightBarButtonItem = nil
      }
    }
  }
  
  let load: (@escaping ([Model]) -> ()) -> ()
  
  let cellDescriptor: (Model) -> CellDescriptor
  let rowHeight: (Model, IndexPath) -> RowHeight
  
  var itemForIndexPath: ((IndexPath) -> Model?)! {
    didSet {
      tableView.reloadData()
    }
  }
  
  var didSelect: (Model) -> Void = { _ in }
  
  //******** Right Item ***********
  
  var rightItem: (UIImage?, UIBarButtonItemStyle) {
    didSet {
      let (image, style) = rightItem
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                          style: style,
                                                          target: self,
                                                          action: #selector(choseRightItem(_:)))
    }
  }
  
  @objc fileprivate func choseRightItem(_ item: UIBarButtonItem) {
    didChooseRightItem(item)
  }
  
  var didChooseRightItem: (UIBarButtonItem) -> Void = { _ in }
  
  //********************************
  
  fileprivate var fabButton: UIButton!
  
  // Style the floating action button here.
  var fabStyle: ((UIButton) -> [NSLayoutConstraint]?)? {
    didSet {
      if fabButton.superview == nil { return }
      
      NSLayoutConstraint.deactivate(fabButton.constraints)
      if let constraints = fabStyle?(fabButton) {
        NSLayoutConstraint.activate(constraints)
      }
      
      fabButton.isHidden = (fabStyle == nil)
    }
  }
  
  // If you want a floating action button. Return function that it will call on .touchUpInside.
  var fabAction: ((Void) -> (UIButton) -> Void)?
  
  var sections: (ModelTableViewController<Model>) -> Int = { _ in 1 } {
    didSet {
      tableView.reloadData()
    }
  }
  
  var rowsInSection: ((Int) -> Int)! {
    didSet {
      tableView.reloadData()
    }
  }
  
  var header: (Int) -> (RowHeight, Header?) = { _ in (.automatic, nil) } {
    didSet {
      tableView.reloadData()
    }
  }
  
  init(style: UITableViewStyle = .plain,
       isIncremental: Bool = false, // Do we replace the array each time or simply append to it? This only exists bc Firebase.
       load: @escaping (@escaping ([Model]) -> ()) -> (),
       cellDescriptor: @escaping (Model) -> CellDescriptor,
       itemForIndexPath: ((IndexPath) -> Model)? = nil,
       rowsInSection: ((Int) -> Int)? = nil,
       rowHeight: @escaping (Model, IndexPath) -> RowHeight)
  {
    self.isIncremental = isIncremental
    self.load = load
    
    self.cellDescriptor = cellDescriptor
    self.rowHeight = rowHeight
    
    self.rightItem = (nil, .plain)
    
    super.init(style: style)
    
    self.itemForIndexPath = itemForIndexPath ?? { [weak self] in
      self?.filteredItems[$0.row]
    }
    self.rowsInSection = rowsInSection ?? { [weak self] _ in
      self?.filteredItems.count ?? 0
    }
    
    addRefreshControl()
    
    fabButton = UIButton(frame: .zero)
    fabButton.addTarget(self, action: #selector(handleFAB(_:)), for: .touchUpInside)
    fabButton.isHidden = true
    
    fabButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(fabButton)
    
    if let constraints = fabStyle?(fabButton), let _ = fabAction {
      NSLayoutConstraint.activate(constraints)
      fabButton.isHidden = false
    }
    
    navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: spinner)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: empty state?
    setLoading(true)
    load { [weak self] items in
      self?.setLoading(false)
      self?.reload(items: items)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateHeaderViewIfNeeded()
    localReload()
  }
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  //MARK: UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = itemForIndexPath(indexPath)!
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
    return rowsInSection(section)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections(self)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item = itemForIndexPath(indexPath)!
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
    guard case .view(let v)? = header(section).1 else { return nil }
    return v
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard case .title(let t)? = header(section).1 else { return nil }
    return t
  }
  
  //MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = itemForIndexPath(indexPath)!
    didSelect(item)
  }
  
  //MARK: UIScrollViewDelegate
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateHeaderViewIfNeeded()
    
    if let bottomConstraint = view.constraints.filter({ $0.firstAnchor == fabButton.bottomAnchor }).first {
      bottomConstraint.constant = -8 + scrollView.contentOffset.y
      view.layoutIfNeeded()
    }
  }
  
  //MARK: Actions
  
  @objc func refresh(sender: UIRefreshControl?) {
    items.removeAll()
    setLoading(true)
    load { [weak self] items in
      sender?.endRefreshing()
      self?.setLoading(false)
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
  
  //MARK: FAB
  
  @objc fileprivate func handleFAB(_ sender: UIButton) {
    guard let f = fabAction?() else { return }
    f(sender)
  }
  
  //MARK: Helpers
  
  func reload(items: [Model]) {
    if isIncremental {
      self.items.append(contentsOf: items)
    } else {
      self.items = items
    }
  }
  
  fileprivate func setLoading(_ loading: Bool) {
    if showsIndicator {
      spinner.setAnimating(loading)
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
