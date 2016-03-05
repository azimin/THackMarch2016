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
    let carrier = "SU"
    let flightnumber = "2318"
    let year = "2016"
    let month = "03"
    let day = "07"
    let url = "https://api.flightstats.com/flex/schedules/rest/v1/json/flight/\(carrier)/\(flightnumber)/departing/\(year)/\(month)/\(day)?appId=b0c11341&appKey=c612607cd5a900de873d3a50d8b3470e"
    Alamofire.request(.GET, url).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        break
      case .Success(let data):
        print(data)
        break
      }
    }
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