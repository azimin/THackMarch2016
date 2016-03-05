//
//  AddTripResultsTableViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class HelperMethods {
  static func makeArrowFrom(pointA: String, toPointB pointB: String) -> String {
    return "\(pointA) ➠ \(pointB)"
  }
}

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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tripEntity = TripEntity()
    let flight = flights[indexPath.row]
    tripEntity.flightNumber = flight.formattedNumber ?? ""
    tripEntity.fromCity = departure ?? ""
    tripEntity.toCity = destination ?? ""
    tripEntity.time = flight.duration
    
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    tripEntity.date = dateFormat.dateFromString(date ?? "1995-05-19")!
    
    realmDataBase.writeFunction({ () -> Void in
      realmDataBase.add(tripEntity)
    })
    
    realmDataBase.writeFunction { () -> Void in
      ClientModel.sharedInstance.tripsCount += 1
    }
    ClientModel.sharedInstance.fetchBack()
    
    NSNotificationCenter.defaultCenter().postNotificationName("UpdateTrips", object: nil)
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return flights.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FlightSearchResultTableViewCell
    let flight = flights[indexPath.row]
    cell.flightNameLabel.text = flight.formattedNumber != nil ? "#\(flight.formattedNumber!)" : ""
    cell.flightTimeLabel.text = "\(flight.duration) min"
    cell.flightDestinationLabel.text = HelperMethods.makeArrowFrom(departure ?? "", toPointB: destination ?? "")
    return cell
  }
  
}
