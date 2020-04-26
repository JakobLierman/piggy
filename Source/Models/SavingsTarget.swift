//
//  SavingsTarget.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class SavingsTarget: Object {
    
    // MARK: Properties
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var price: Double = 0
    dynamic var balance: Double = 0
    dynamic var category: Category? = nil
    dynamic var deadline: Date? = nil
    dynamic var createdAt: Date = Date()
    
    // MARK: Constructors
    convenience init(name: String, price: Double, balance: Double?, category: Category?, deadline: Date?) throws {
        self.init()
        
        guard name.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            throw SavingsTargetError.emptyNameError
        }
        guard price > 0 else {
            throw SavingsTargetError.noPriceError
        }
        guard (balance ?? 0) <= (price - 1) else {
            throw SavingsTargetError.balanceError(maxBalance: price - 1)
        }
        if deadline != nil {
            guard deadline! > Date() else {
                throw SavingsTargetError.dateToEarly(earliestDate: Date())
            }
        }
        
        self.name = name
        self.price = price
        self.balance = balance ?? 0
        self.category = category
        self.deadline = deadline
    }
    
    // MARK: Functions
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["createdAt"]
    }
    
    func getRemainingTime() -> Double {
        return deadline!.timeIntervalSinceNow
    }
    
    func addBalance(amount: Double) {
        let db = RealmService.shared
        let amountToAdd = (self.balance + amount) > self.price ? self.price - self.balance : amount
        db.update(self, with: ["balance": (self.balance + amountToAdd)])
    }
    
}

enum SavingsTargetError: Error {
    case emptyNameError
    case noPriceError
    case balanceError(maxBalance: Double)
    case dateToEarly(earliestDate: Date)
}
