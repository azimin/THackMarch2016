//
//  TalkTableViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 06/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import SDWebImage
import Parse
import SVProgressHUD

class TalkTableViewController: UITableViewController {
  
  var talk: TalkEntity!
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var creditsLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var collaboratorsButton: THStyleButton!
  @IBOutlet weak var participateButton: THStyleButton!
  
  var shouldJumpBack = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    participateButton.hidden = true
    talk.calculateCouldParticipate()   
     
    photoImageView.sd_setImageWithURL(NSURL(string: "https://graph.facebook.com/\(talk.authorId)/picture?height=220"), placeholderImage: nil) { (image, error, cache, url) -> Void in
      self.activityIndicator.hidden = true
    }
    
    photoImageView.layer.masksToBounds = true
    
    nameLabel.text = talk.name
    creditsLabel.text = "\(talk.cost) CREDITS"
    descriptionLabel.text = talk.talkDescription
    
    calculateCaloborationCount()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateTable"), name: "UpdateCouldParticipate", object: nil)
  }
  
  func goBack() {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.navigationController?.viewControllers.indexOf(self) ?? 0 == NSNotFound {
      print("Swag")
    }
  }

  func calculateCaloborationCount() {
    self.collaboratorsButton.setTitle("Loading...", forState: .Normal)
    let query = PFQuery(className:"Talk")
    query.whereKey("uniqId", equalTo: talk.uniqId)
    query.getFirstObjectInBackgroundWithBlock { (talk, error) -> Void in
      guard let talk = talk else {
        return
      }
      
      let relation = talk.relationForKey("Users")
      relation.query().countObjectsInBackgroundWithBlock({ (count, error) -> Void in
        self.collaboratorsButton.setTitle("\(count) Collaborators", forState: .Normal)
      })
    }
  }
  
  func updateTable() {
    participateButton.hidden = !talk.couldParticipate
    tableView.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
  }
  
  @IBAction func participateButtonAction(sender: THStyleButton) {
    shouldJumpBack = true
    
    SVProgressHUD.show()
    talk.addCollaboratingPerson(ClientModel.sharedInstance.facebookId) {
      self.talk.calculateCouldParticipate()
      self.calculateCaloborationCount()
      SVProgressHUD.dismiss()
    }
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = super.tableView(tableView, numberOfRowsInSection: section)
    return talk.couldParticipate ? count : count - 1
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 1 {
      return UCTextFrameAttributes(string: descriptionLabel.text ?? "", width: 280, font: descriptionLabel.font).textHeight + 16
    }
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }
}
