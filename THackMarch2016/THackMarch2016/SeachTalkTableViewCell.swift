//
//  SeachTalkTableViewCell.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 06/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class SeachTalkTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var creditsLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.whiteColor()
    separatorView.alpha = 0.5
    
    self.addSubview(separatorView)
    
    separatorView.autoSetDimension(.Height, toSize: 0.5)
    separatorView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
    
    separatorView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self, withOffset: 16)
    separatorView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self, withOffset: -16)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
