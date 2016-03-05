//
//  THUnderlineButton.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation

class THUnderlineButton: UIButton {
  @IBInspectable var isCornerRounded: Bool = false
  
  var titleColor: UIColor = UIColor.whiteColor() {
    didSet {
      updateTitleString()
    }
  }
  
  var titleString: String? {
    didSet {
      updateTitleString()
    }
  }
  
  override func setTitleColor(color: UIColor?, forState state: UIControlState) {
    super.setTitleColor(color, forState: state)
    titleColor = color ?? titleColor
  }
  
  override func setTitle(title: String?, forState state: UIControlState) {
    super.setTitle(title?.uppercaseString, forState: state)
    titleString = title
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleString = self.titleForState(.Normal)
    titleColor = self.titleColorForState(.Normal) ?? titleColor
  }
  
  func updateTitleString() {
    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: titleColor]
    let underlineAttributedString = NSAttributedString(string: titleString ?? "", attributes: underlineAttribute)
    self.setAttributedTitle(underlineAttributedString, forState: .Normal)
  }

}