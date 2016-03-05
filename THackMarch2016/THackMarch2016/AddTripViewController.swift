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
  
  @IBOutlet weak var departureTextField: HoshiTextField!
  @IBOutlet weak var destinationTextField: HoshiTextField!
  @IBOutlet weak var dateTextField: HoshiTextField!
  
  
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

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Show Search Results Segue" {
      let destVC = segue.destinationViewController as! AddTripResultsTableViewController
      destVC.departure = departureTextField.text
      destVC.destination = destinationTextField.text
      destVC.date = dateTextField.text
    }
  }
  
}

extension AddTripViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField == dateTextField {
      (textField as! HoshiTextField).animateViewsForTextDisplay()
      
      DatePickerDialog().show("Pick a date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.selectedDate ?? NSDate(), datePickerMode: UIDatePickerMode.Date) { (date) -> Void in
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        if let date = date {
          self.selectedDate = date
          textField.text = dateFormat.stringFromDate(date)
        }
      }
      return false
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
