//
//  CreateTalkTableViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 06/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import TextFieldEffects

class CreateTalkTableViewController: UITableViewController {
  
  var trip: TripEntity!
  
  @IBOutlet weak var titleTextField: HoshiTextField!
  @IBOutlet weak var costTextField: HoshiTextField!
  @IBOutlet weak var descriptionTextField: HoshiTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(trip.myTalk)
  }
  
  @IBAction func saveButtonAction(sender: AnyObject) {
    let talk = TalkEntity()
    
    talk.name = titleTextField.text ?? ""
    talk.cost = Int(costTextField.text ?? "") ?? 0
    talk.talkDescription = descriptionTextField.text ?? ""
    talk.authorId = "10208883158461635"// ClientModel.sharedInstance.facebookId
    
    realmDataBase.writeFunction { () -> Void in
      realmDataBase.add(talk)
    }
    
    talk.add(trip) {
      self.performSegueWithIdentifier("ShowTalk", sender: talk)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let controller = segue.destinationViewController as! TalkTableViewController
    controller.talk = sender as! TalkEntity
  }
}


extension CreateTalkTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
