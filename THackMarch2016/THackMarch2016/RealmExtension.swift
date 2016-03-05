//
//  RealmExtension.swift
//  Hitch
//
//  Created by Alex Zimin on 14/11/15.
//  Copyright © 2015 Triagne glow. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  public func writeFunction(block: (() -> Void)) {
    if realmDataBase.inWriteTransaction {
      block()
    } else {
      do {
        try write(block)
      } catch { }
    }
  }
}