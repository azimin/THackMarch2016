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
  
  var allTrips = TripEntity.allTrips
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    (self.tabBarController as? AZTabBarController)?.setHidden(false, animated: true)
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "TRIPS"
    
    self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateData"), name: "UpdateTrips", object: nil)
  }

  
  func updateData() {
    allTrips = TripEntity.allTrips
    tableView.reloadData()
  }
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = TabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = TabBarItem.TabBarItemType.Trips
    return cell
  }
  
  @IBAction func addTripButtonAction(sender: UIBarButtonItem) {
    (self.tabBarController as? AZTabBarController)?.setHidden(true, animated: true)
    self.performSegueWithIdentifier("AddTrip", sender: nil)
  }
  
}

extension TripsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let headerCell = TripsHeaderView.createCell()
    
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "dd MMM"
    headerCell.titleLabel.text = dateFormat.stringFromDate(allTrips[section].date)
    
    view.addSubview(headerCell)
    headerCell.autoPinEdgesToSuperviewEdges()
    return view
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return allTrips.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TripTableViewCell
    
    let trip = allTrips[indexPath.section]
    cell.time = trip.time
    cell.routeLabel.text = HelperMethods.makeArrowFrom(trip.fromCity, toPointB: trip.toCity)
    
    if indexPath.section == allTrips.count - 1 {
      cell.addSeperator()
    }
    
    switch TripEntityType(rawValue: trip.status)! {
    case .Talk:
      if trip.myTalk != nil {
        cell.statusButton.setTitle("EDIT TOPIC", forState: .Normal)
        cell.statusButton.setTitleColor(UIColor(hex: "A7DD38"), forState: .Normal)
      } else {
        cell.statusButton.setTitle("ADD TOPIC", forState: .Normal)
        cell.statusButton.setTitleColor(UIColor(hex: "F12138"), forState: .Normal)
      }
    case .Collaborate:
      if let _ = TalkEntity.isParticipate(trip) {
        cell.statusButton.setTitle("VIEW TOPIC", forState: .Normal)
        cell.statusButton.setTitleColor(UIColor(hex: "A7DD38"), forState: .Normal)
      } else {
        cell.statusButton.setTitle("SELECT TOPIC", forState: .Normal)
        cell.statusButton.setTitleColor(UIColor(hex: "F12138"), forState: .Normal)
      }
      
    default:
      break
    }
    
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowTalkEdit" {
      let viewController = segue.destinationViewController as! CreateTalkTableViewController
      viewController.trip = sender as! TripEntity
    } else if segue.identifier == "ShowTalk" { 
      let talk = sender as! TalkEntity
      talk.calculateCouldParticipate()
      
      let viewController = segue.destinationViewController as! TalkTableViewController
      viewController.talk = talk
    } else if segue.identifier == "ShowTripEvents" { 
      let viewController = segue.destinationViewController as! SeachTalkTableViewController
      viewController.trip = sender as! TripEntity
    }
  }
}

extension TripsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80 + 32
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    (self.tabBarController as? AZTabBarController)?.setHidden(true, animated: true)
    
    let trip = allTrips[indexPath.section]
    
    switch TripEntityType(rawValue: trip.status)! {
    case .Talk:
      if trip.myTalk != nil {
        self.performSegueWithIdentifier("ShowTalk", sender: trip.myTalk)
      } else {
        self.performSegueWithIdentifier("ShowTalkEdit", sender: trip)
      }
    case .Collaborate:
      if let talk = TalkEntity.isParticipate(trip) {
        self.performSegueWithIdentifier("ShowTalk", sender: talk)
      } else {
        self.performSegueWithIdentifier("ShowTripEvents", sender: trip)
      }
      
    default:
      return
    }
  }
}