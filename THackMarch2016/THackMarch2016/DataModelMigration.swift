//
//  DataModelMigration.swift
//  RealmPlay
//
//  Created by Alex Zimin on 24/10/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class DataModelMigration {
  static func migrationBlock() -> MigrationBlock {
    let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
      var flag = false
      if oldSchemaVersion < 1 {
        flag = true
        fromFirstToSecond(migration, oldSchemaVersion: oldSchemaVersion)
      }
      
      if !flag {
        fatalError("Must no be reached")
      }
    }
    return migrationBlock
  }
  
  
  static func fromFirstToSecond(migration: RealmSwift.Migration, oldSchemaVersion: UInt64) {
//    migration.enumerate(Statistic.className()) { oldObject, newObject in
//      newObject?["info"] = "Swag"
//         combine name fields into a single field
//          let firstName = oldObject!["firstName"] as! String
//          let lastName = oldObject!["lastName"] as! String
//          newObject?["fullName"] = "\(firstName) \(lastName)"
//    }
  }
}