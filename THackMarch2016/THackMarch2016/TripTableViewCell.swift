//
//  TripTableViewCell.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var routeLabel: UILabel!
  @IBOutlet weak var statusButton: THStyleButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    timeLabel.text = "120\nmin"
  }
  
  var separatorView: UIView!
  
  func addSeperator() {
    separatorView?.removeFromSuperview()
    
    separatorView = UIView()
    separatorView.backgroundColor = UIColor.whiteColor()
    separatorView.alpha = 0.5
    
    self.addSubview(separatorView)
    
    separatorView.autoSetDimension(.Height, toSize: 0.5)
    separatorView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
    
    
    separatorView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
    separatorView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)
  }
  
  var time: Int = 0 {
    didSet {
      timeLabel.text = "\(time)\nmin"
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
