//
//  ViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import SVProgressHUD
import Spring
import SwiftyJSON
import Parse

class LoginViewController: UIViewController {

  @IBOutlet weak var logoImageView: SpringImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    logoImageView.animation = "pop"
    logoImageView.repeatCount = FLT_MAX
    logoImageView.force = 0.75
    logoImageView.duration = 1.7
    logoImageView.curve = "spring"
    logoImageView.animate()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  @IBAction func loginWithFacebookAction(sender: UIButton) {

    let login = FBSDKLoginManager()
    login.logInWithReadPermissions(["public_profile", "email", "user_work_history"], fromViewController: self) { (result, error) -> Void in
      if error != nil { 
        print("Error")
      } else if result.isCancelled {
        print("Cencelled")
      } else {
        self.fetchUser()
      }
    }
  }
  
  func fetchUser() {
    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "work,email,name,gender,about"]).startWithCompletionHandler({ (connection, result, error) -> Void in
      print(result)
      let json = JSON(result)
      
      let userID = json["id"].stringValue
      
      realmDataBase.writeFunction({ () -> Void in
        ClientModel.sharedInstance.facebookId = json["id"].stringValue
      })
      ClientModel.sharedInstance.loadImage()
      
      let query = PFQuery(className:"AppUser")
      query.whereKey("facebookID", equalTo: userID)
      query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
        if object == nil && error?.code ?? 0 == 101 {
          let gameScore = PFObject(className:"AppUser")
          gameScore["facebookID"] = json["id"].stringValue
          gameScore["username"] = json["name"].stringValue
          gameScore["email"] = json["email"].stringValue
          gameScore["tripsCount"] = 0
          gameScore["talksCount"] = 0
          gameScore["collaborationsCount"] = 0
          gameScore["creditsCount"] = 0
          gameScore["gender"] = json["gender"].string
          
          gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
              print("Succes")
              (UIApplication.sharedApplication().delegate as! AppDelegate).presentNesessaryWindow()
            } else {
              print(error)
            }
          }
        } else if object != nil {
          (UIApplication.sharedApplication().delegate as! AppDelegate).presentNesessaryWindow()
        }
      })
    })
    
  }
  
}

class FacebookManager {
  static let sharedInstance = FBSDKLoginManager()
}