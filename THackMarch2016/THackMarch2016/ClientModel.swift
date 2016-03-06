//
//  ClientModel.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation
import RealmSwift
import Parse
import SDWebImage

class ClientModel: Object, ObjectSingletone {
  static var sharedInstance: ClientModel = {
    return value
  }()
  
  static func resetObject() {
    sharedInstance = value
  }
  
  dynamic var facebookId: String = ""
  dynamic var name: String?
  dynamic var gender: String?
  dynamic var email: String?
  dynamic var talksCount = 0
  dynamic var tripsCount = 0
  dynamic var collaborationsCount = 0
  dynamic var creditsCount = 0
  
  dynamic var imageData: NSData?
  
  var image: UIImage? {
    if let imageData = imageData {
      return UIImage(data: imageData)
    }
    return nil
  }
  
  func fetchData() {
    guard facebookId.length > 0 else {
      return
    }
    
    requestCurrentUser { (object) -> () in
      guard let object = object else {
        return
      }
      
      realmDataBase.writeFunction({ () -> Void in
        self.name = object["username"] as? String
        self.email = object["email"] as? String
        self.gender = object["gender"] as? String
        self.talksCount = object["talksCount"] as? Int ?? 0
        self.tripsCount = object["tripsCount"] as? Int ?? 0
        self.collaborationsCount = object["collaborationsCount"] as? Int ?? 0
        self.creditsCount = object["creditsCount"] as? Int ?? 0
      })
    }
  }
  
  func fetchBack() {
    requestCurrentUser { (object) -> () in
      guard let object = object else {
        return
      }
      
      object["talksCount"] = self.talksCount
      object["tripsCount"] = self.tripsCount
      object["collaborationsCount"] = self.collaborationsCount
      object["creditsCount"] = self.creditsCount
      
      object.saveInBackground()
    }
  }
  
  func requestCurrentUser(completion: (PFObject?) -> ()) {
    let query = PFQuery(className:"AppUser")
    query.whereKey("facebookID", equalTo: facebookId)
    query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
      completion(object)
    }
  }
  
  func loadImage() {
    guard imageData?.length ?? 0 == 0 && facebookId.length > 0 else {
      return
    }
    
    let manager = SDWebImageManager.sharedManager()
    let pictureURL = NSURL(string: "https://graph.facebook.com/\(ClientModel.sharedInstance.facebookId)/picture?height=220")
    
    manager.downloadImageWithURL(pictureURL, options: SDWebImageOptions.RetryFailed, progress: nil) { (image, error, cacheType, sucess, url) -> Void in
      if let image = image {
        realmDataBase.writeFunction({ () -> Void in
          self.imageData = UIImagePNGRepresentation(image)
        })
      }
    }
  }

}