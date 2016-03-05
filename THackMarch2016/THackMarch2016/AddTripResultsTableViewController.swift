//
//  AddTripResultsTableViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class AddTripResultsTableViewController: UITableViewController {
  
  var departure: String?
  var destination: String?
  var date: String?
  var flights = [Flight]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 64
    
    self.title = "TRIPS"
    
    guard let departure = departure, destination = destination, date = date else {
      return
    }
    
    SkyScannerAuth.sharedInstance.getLocationName(departure) { departureId in
      SkyScannerAuth.sharedInstance.getLocationName(destination) { destinationId in
        let fp = FlightsParser()
        fp.flightFromAirport(departureId, toAirport: destinationId, onData: date, withCabinClass: "Business") {
          flights in
            self.flights = flights
            self.tableView.reloadData()
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

    // Configure the cell...
    
    return cell
  }
  
}
