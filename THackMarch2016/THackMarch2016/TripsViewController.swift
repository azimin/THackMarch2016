//
//  TripsViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "TRIPS"
    
    let fp = FlightsParser()
    fp.flightFromAirport("BERL-sky", toAirport: "MOSC-sky", onData: "2016-03-07", withCabinClass: "Business") {
      flights in
      // Do your work with flights here
    }
    SkyScannerAuth.sharedInstance.getLocationName("Berlin") { name in
      print(name)
    }
  }
  
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = TabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = TabBarItem.TabBarItemType.Trips
    return cell
  }
  
}
