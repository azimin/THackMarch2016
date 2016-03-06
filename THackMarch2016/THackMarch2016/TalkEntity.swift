//
//  TalkEntity.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 06/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation
import RealmSwift
import Parse

class TalkEntity: Object {
  dynamic var authorId = ""
  dynamic var name = ""
  dynamic var talkDescription = ""
  dynamic var cost = 0
  dynamic var numberOfCollaboratingPeople = 0
  dynamic var tripUniqId = ""
  
  var uniqId: String {
    return tripUniqId + authorId
  }
  
  static var allTrips: Results<TalkEntity> {
    return realmDataBase.objects(TalkEntity)
  }
  
  func calculateCouldParticipate() {
    if authorId == ClientModel.sharedInstance.facebookId {
      couldParticipate = false
      return
    }
    
    let query = PFQuery(className:"Talk")
    query.whereKey("tripUniqId", equalTo: tripUniqId)
    query.getFirstObjectInBackgroundWithBlock { (talk, error) -> Void in
      guard let talk = talk else {
        return
      }
      
      let relation = talk.relationForKey("Users")
      let query = relation.query().whereKey("facebookID", equalTo: ClientModel.sharedInstance.facebookId)
      query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
        self.couldParticipate = (object == nil)
      })
    }
  }
  
  private(set) var couldParticipate: Bool = true {
    didSet {
      if oldValue != couldParticipate {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateCouldParticipate", object: nil)
      }
    }
  }
  
  func add(tripEntity: TripEntity, completion: () -> ()) {
    realmDataBase.writeFunction { () -> Void in
      self.tripUniqId = tripEntity.uniqId
    }
    
    let query = PFQuery(className: "Trip")
    query.whereKey("uniqId", equalTo: tripUniqId)
    query.getFirstObjectInBackgroundWithBlock { (trip, error) -> Void in
      guard let trip = trip else {
        return
      }
      
      let relation = trip.relationForKey("Talks")
      
      let object = PFObject(className: "Talk")
      object["authorId"] = self.authorId
      object["name"] = self.name
      object["talkDescription"] = self.talkDescription
      object["cost"] = self.cost
      object["tripUniqId"] = tripEntity.uniqId
      object["uniqId"] = self.uniqId
      
      try! object.save()
      
      relation.addObject(object)
      
      object.saveInBackground()
      trip.saveInBackground()
      completion()
    }
  }
  
  func addCollaboratingPerson(personFacebookId: String, completion: () -> ()) {
    let query = PFQuery(className:"Talk")
    query.whereKey("tripUniqId", equalTo: tripUniqId)
    query.getFirstObjectInBackgroundWithBlock { (talk, error) -> Void in
      guard let talk = talk else {
        completion()
        return
      }
      
      let userQuery = PFQuery(className:"AppUser")
      userQuery.whereKey("facebookID", equalTo: personFacebookId)
      userQuery.getFirstObjectInBackgroundWithBlock({ (user, error) -> Void in
        guard let user = user else {
          completion()
          return
        }
        let relation = talk.relationForKey("Users")
        relation.addObject(user)
        talk.saveInBackground()
        completion()
      })
    }
  }
  
  static func loadForCurrentTripObject(tripObject: PFObject, completion: () -> ()) {
    var keys: [String] = []
    for trip in TalkEntity.allTrips {
      keys.append(trip.uniqId)
    }
    
    
    let relation = tripObject.relationForKey("Talks")
    let query = relation.query()
    query.whereKey("uniqId", notContainedIn: keys)
    
    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
      print("TALK: Finded \(objects?.count ?? 0) objects")
      for object in objects ?? [] {
        
        let tripEntity = TalkEntity()
        
        tripEntity.authorId = object["authorId"] as! String
        tripEntity.name = object["name"] as! String
        tripEntity.talkDescription = object["talkDescription"] as! String
        tripEntity.cost = object["cost"] as! Int
        tripEntity.tripUniqId = object["tripUniqId"] as! String
        
        realmDataBase.writeFunction({ () -> Void in
          realmDataBase.add(tripEntity)
        })
        
        tripEntity.calculateCouldParticipate()
      }
      
      completion()
    })
  }
}