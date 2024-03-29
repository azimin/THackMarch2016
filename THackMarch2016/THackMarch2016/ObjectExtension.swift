//
//  ObjectExtension.swift
//  Juicy Bubble
//
//  Created by Alex Zimin on 26/10/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

func dispatchAfter(time: NSTimeInterval, executionBlock: () -> ()) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
    executionBlock()
  })
}

protocol ObjectSingletone: class {
  init()
}

extension ObjectSingletone where Self: Object {
  static var value: Self {
    let object = realmDataBase.objects(Self).first
    if let value = object {
      return value
    } else {
      let value = Self()
      
      if realmDataBase.inWriteTransaction {
        realmDataBase.add(value) 
      } else {
        realmDataBase.writeFunction({ () -> Void in
          realmDataBase.add(value)
        })
      }
      
      return value
    }
  }
}

extension Object {
  func firstSave() -> Self {
    if realmDataBase.inWriteTransaction {
      realmDataBase.add(self)
    } else {
      realmDataBase.writeFunction({ () -> Void in
        realmDataBase.add(self)
      })
    }
    return self
  }
}

extension List {
  func appendInContext(object: T) {
    realmDataBase.beginWrite()
    self.append(object)
    
    do {
      try realmDataBase.commitWrite()
    } catch {}
  }
}