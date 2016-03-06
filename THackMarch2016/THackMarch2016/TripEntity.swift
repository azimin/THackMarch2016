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
      
      let object = PFObject(className: "Trip")
      object["fromCity"] = self.fromCity
      object["toCity"] = self.toCity
      object["time"] = self.time
      object["flightNumber"] = self.flightNumber
      object["status"] = self.status
      object["date"] = self.date
      object["uniqId"] = self.uniqId
      
      try! object.save()
      
      relation.addObject(object)
      
      object.saveInBackground()
      user.saveInBackground()
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