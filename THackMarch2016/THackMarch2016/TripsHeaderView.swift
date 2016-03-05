//
//  UCUserProfileLoginMethodHeaderView.swift
//  Uberchord
//
//  Created by Alex Zimin on 25/02/16.
//  Copyright © 2016 Uberchord Engineering. All rights reserved.
//

import UIKit


class TripsHeaderView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    addSeperator(true)
    addSeperator(false)
  }
  
  func addSeperator(isTop: Bool) {
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.whiteColor()
    separatorView.alpha = 0.5
    
    self.addSubview(separatorView)
    
    separatorView.autoSetDimension(.Height, toSize: 0.5)
    
    if isTop {
      separatorView.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: -1)
    } else {
      separatorView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: 1)
    }
    
    separatorView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
    separatorView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)
  }
  
  static func createCell() -> TripsHeaderView {
    return TripsHeaderView().az_loadFromNibIfEmbeddedInDifferentNib()
  }

}
