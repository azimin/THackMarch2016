//
//  FlightSearchResultTableViewCell.swift
//  THackMarch2016
//
//  Created by Vadim Drobinin on 5/3/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class FlightSearchResultTableViewCell: UITableViewCell {

  @IBOutlet weak var flightNameLabel: UILabel!
  @IBOutlet weak var flightDestinationLabel: UILabel!
  @IBOutlet weak var flightTimeLabel: UILabel!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
}
