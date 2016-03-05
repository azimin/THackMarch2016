//
//  AddTripViewController.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddTripViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "ADD TRIP"
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var selectedDate: NSDate?
  
  @IBAction func dateEditingBeganAction(sender: HoshiTextField) {
    
    dispatchAfter(0.05) { () -> () in
      
      sender.resignFirstResponder()
      sender.animateViewsForTextDisplay()
      
      DatePickerDialog().show("Pick a date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.selectedDate ?? NSDate(), datePickerMode: UIDatePickerMode.Date) { (date) -> Void in
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        if let date = date {
          self.selectedDate = date
          sender.text = dateFormat.stringFromDate(date)
        }
      }
    }
    
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

extension AddTripViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
