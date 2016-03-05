//
//  ViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import SVProgressHUD
import Spring

class LoginViewController: UIViewController {

  @IBOutlet weak var logoImageView: SpringImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    logoImageView.animation = "pop"
    logoImageView.repeatCount = FLT_MAX
    logoImageView.force = 0.75
    logoImageView.duration = 1.7
    logoImageView.curve = "spring"
    logoImageView.animate()

    let fp = FlightsParser()
    fp.flightFromAirport("BERL-sky", toAirport: "MOSC-sky", onData: "2016-03-07", withCabinClass: "Business") {
      flights in
      // Do your work with flights here
    }

  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

}
