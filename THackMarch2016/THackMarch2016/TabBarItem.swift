//
//  BrieTabBarItem.swift
//  Brie
//
//  Created by Alex Zimin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import UIKit

class TabBarItem: AZTabBarItemView {
  enum TabBarItemType: String {
    case Trips = "img_tab-bar_tripes"
    case Profile = "img_tab-bar_profile"
    case Setting = "img_tab-bar_settings"
    
    var image: UIImage {
      return UIImage(named: self.rawValue)!
    }
  }
  
  @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint! {
    didSet {
      seperatorHeightConstraint.constant = 0.5
    }
  }
  
  override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
    return self.az_loadFromNibIfEmbeddedInDifferentNib()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.th_blackColor
  }
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  var type: TabBarItemType = .Trips {
    didSet {
      iconImageView.image = type.image
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    self.selectionImageView.alpha = selected ? 1.0 : 0.0
    self.iconImageView.alpha = selected ? 1.0 : 0.5
  }
}