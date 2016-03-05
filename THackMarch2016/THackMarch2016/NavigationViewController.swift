//
//  NavigationViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
  
  var separatorView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.translucent = false
    
    updateUI()
    // Do any additional setup after loading the view.
  }
  
  func updateUI() {
    let textAttributes: [String: AnyObject!] = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Oswald-Medium", size: 17)]
    self.navigationBar.titleTextAttributes = textAttributes
    
    self.navigationBar.setBackgroundImage(UIImage.imageFromColor(UIColor.blackColor()), forBarMetrics: UIBarMetrics.Default)
    self.navigationBar.tintColor = UIColor.whiteColor()
    
    self.setNeedsStatusBarAppearanceUpdate()
    addSeparator()
  }
  
  func addSeparator() {
    separatorView?.removeFromSuperview()
    
    separatorView = UIView()
    separatorView.backgroundColor = UIColor.whiteColor()
    separatorView.alpha = 0.5
    
    self.navigationBar.addSubview(separatorView)
    
    separatorView.autoSetDimension(.Height, toSize: 0.5)
    separatorView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.navigationBar)
    separatorView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.navigationBar)
    separatorView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.navigationBar)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
}
