//
//  Transaction.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Transaction: Object {
    
    // MARK: Properties
    dynamic var id: String = UUID().uuidString
    dynamic var savingsTarget: SavingsTarget? = SavingsTarget()
    dynamic var amount: Double = 0
    dynamic var isAddition: Bool = true
    dynamic var createdAt: Date = Date()
    
    // MARK: Constructors
    convenience init(id: String?, savingsTarget: SavingsTarget?, amount: Double, isAddition: Bool?, createdAt: Date?) {
        self.init()
        self.id = id ?? UUID().uuidString
        self.savingsTarget = savingsTarget ?? SavingsTarget()
        self.amount = amount
        self.isAddition = isAddition ?? true
        self.createdAt = createdAt ?? Date()
    }
    
    // MARK: Functions
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["createdAt"]
    }
    
}
