//
//  THStyleButton.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class THStyleButton: UIButton {
  var titleColor: UIColor = UIColor.whiteColor() {
    didSet {
      setNeedsLayout()
    }
  }
  
  override func setTitleColor(color: UIColor?, forState state: UIControlState) {
    super.setTitleColor(color, forState: state)
    titleColor = color ?? titleColor
  }
  
  override func setTitle(title: String?, forState state: UIControlState) {
    super.setTitle(title?.uppercaseString, forState: state)
  }
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 4
    self.layer.borderWidth = 2
    self.titleLabel?.font = UIFont(name: "Oswald-Medium", size: 14)
    
    titleColor = self.titleColorForState(.Normal) ?? titleColor
    setTitle(self.titleForState(.Normal), forState: .Normal)
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    self.autoSetDimension(.Height, toSize: 44)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateAppearance()
  }
  
  private func updateAppearance() {
    self.layer.borderColor = titleColor.CGColor
    self.titleLabel?.textColor = titleColor
  }
}
