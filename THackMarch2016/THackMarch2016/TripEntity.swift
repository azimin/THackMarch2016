//
//  TripEntity.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation
import RealmSwift
import Parse
import SDWebImage

enum TripEntityType: Int {
  case None
  case Talk
  case Collaborate
}

class TripEntity: Object {
  dynamic var fromCity = ""
  dynamic var toCity = ""
  dynamic var time = 0
  dynamic var flightNumber = ""
  dynamic var status = 0
  dynamic var date = NSDate()
  
  var myTalk: TalkEntity? {
    return realmDataBase.objects(TalkEntity).filter(NSPredicate(format: "tripUniqId == %@ && authorId == %@", uniqId, ClientModel.sharedInstance.facebookId)).first
  }
  
  var uniqId: String {
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    return dateFormat.stringFromDate(date) + flightNumber
  }
  
  static var allTrips: Results<TripEntity> {
    return realmDataBase.objects(TripEntity).sorted("date")
  }
  
  func add() {
    ClientModel.sharedInstance.requestCurrentUser { (user) -> () in
      guard let user = user else {
        return
      }
      
      let relation = user.relationForKey("Trips")
      
      var tripObjectToRelations: PFObject!
      
      let query = PFQuery(className:"Trip")
      query.whereKey("uniqId", equalTo: self.uniqId)
      query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
        if object == nil {
          let tripObject = PFObject(className: "Trip")
          tripObject["fromCity"] = self.fromCity
          tripObject["toCity"] = self.toCity
          tripObject["time"] = self.time
          tripObject["flightNumber"] = self.flightNumber
          tripObject["status"] = self.status
          tripObject["date"] = self.date
          tripObject["uniqId"] = self.uniqId
          
          try! tripObject.save()
          tripObjectToRelations = tripObject
        } else {
          tripObjectToRelations = object
        }
        
        relation.addObject(tripObjectToRelations)
        
        tripObjectToRelations.saveInBackground()
        user.saveInBackground()

      }
    }
  }
  
  static func loadAllRelationships(completion: () -> ()) {
    var keys: [String] = []
    for trip in TripEntity.allTrips {
      keys.append(trip.uniqId)
    }
    
    ClientModel.sharedInstance.requestCurrentUser { (user) -> () in
      guard let user = user else {
        return
      }
      
      let relation = user.relationForKey("Trips")
      
      let query = relation.query()
      query.whereKey("uniqId", notContainedIn: keys)
      query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
        print("TRIP: Finded \(objects?.count ?? 0) objects")
        for object in objects ?? [] {
          
          let tripEntity = TripEntity()
          
          tripEntity.fromCity = object["fromCity"] as! String
          tripEntity.toCity = object["toCity"] as! String
          tripEntity.time = object["time"] as! Int
          tripEntity.flightNumber = object["flightNumber"] as! String
          tripEntity.status = object["status"] as! Int
          tripEntity.date = object["date"] as! NSDate
          
          realmDataBase.writeFunction({ () -> Void in
            realmDataBase.add(tripEntity)
          })
          
          TalkEntity.loadForCurrentTripObject(object, completion: { () -> () in
            print("Loaded talk for trip")
          })
          
        }
        
        completion()
      })
    }
  }
}