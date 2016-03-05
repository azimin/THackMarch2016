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
  dynamic var date = ""

static var allTrips: Results<TripEntity> {
    return realmDataBase.objects(TripEntity)
  }
}