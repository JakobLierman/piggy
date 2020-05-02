//
//  User.swift
//  Piggy
//
//  Created by Jakob Lierman on 28/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class User: Object {
    
    // MARK: Properties
    dynamic var name: String = "User"
    dynamic var currency: String = "EUR"
    dynamic var lock: Bool = false
    
    // MARK: Constructors
    convenience init(name: String, currency: String, lock: Bool = false) {
        self.init()
        self.name = name
        self.currency = currency
        self.lock = lock
    }
    
    // MARK: Functions
    func updateName(_ name: String) {
        let db = RealmService.shared
        db.update(self, with: ["name": name])
    }
    
    func updateCurrency(_ currency: String) {
        let db = RealmService.shared
        db.update(self, with: ["currency": currency])
    }
    
    func updateLock(_ lock: Bool) {
        let db = RealmService.shared
        db.update(self, with: ["lock": lock])
    }
    
    static func currentUser() -> User {
        let db = RealmService.shared
        return db.realm.objects(self)[0]
    }
}
