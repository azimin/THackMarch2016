//
//  TripsViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import Alamofire

class TripsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "TRIPS"
  }
  
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = TabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = TabBarItem.TabBarItemType.Trips
    return cell
  }
  
}

extension TripsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
  }
}

extension TripsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }
}