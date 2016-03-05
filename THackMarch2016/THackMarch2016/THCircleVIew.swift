//
//  THCircleVIew.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class THCircleVIew: UIView {
  
  @IBInspectable var circleColor: UIColor = UIColor.whiteColor()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setup()
  }

  func setup() {
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.borderWidth = 2
    self.layer.borderColor = circleColor.CGColor
    self.backgroundColor = UIColor.clearColor()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }

}
