//
//  ProfileViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var workLabel: UILabel!
  
  @IBOutlet weak var tripsCountLabel: UILabel!
  @IBOutlet weak var talksCountLabel: UILabel!
  @IBOutlet weak var collaborationsCountLabel: UILabel!
  
  @IBOutlet weak var creditsCountButton: THStyleButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "PROFILE"
    
    self.nameLabel.text = ClientModel.sharedInstance.name?.uppercaseString ?? ""
    self.workLabel.text = ClientModel.sharedInstance.gender?.uppercaseString ?? "Gender undefined".uppercaseString
    
    self.tripsCountLabel.text = "\(ClientModel.sharedInstance.tripsCount)"
    self.talksCountLabel.text = "\(ClientModel.sharedInstance.talksCount)"
    self.collaborationsCountLabel.text = "\(ClientModel.sharedInstance.collaborationsCount)"
    
    photoImageView.layer.masksToBounds = true
    photoImageView.image = ClientModel.sharedInstance.image
    
    creditsCountButton.setTitle("\(ClientModel.sharedInstance.creditsCount) CREDITS", forState: .Normal)
  }
  
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    let cell = TabBarItem().az_loadFromNibIfEmbeddedInDifferentNib()
    cell.type = TabBarItem.TabBarItemType.Profile
    return cell
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
