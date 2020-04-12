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
    dynamic var balance: Double? = nil
    dynamic var category: Category? = nil
    dynamic var deadline: Date? = nil
    dynamic var imagePath: String? = nil
    //dynamic var transactions: List<Transaction>? = List<Transaction>()
    dynamic var createdAt: Date = Date()
    
    // MARK: Constructors
    convenience init(id: String?, name: String, price: Double, balance: Double?, category: Category?, deadline: Date?, imagePath: String?, createdAt: Date?) {
        self.init()
        self.id = id ?? UUID().uuidString
        self.name = name
        self.price = price
        self.balance = balance
        self.category = category
        self.deadline = deadline
        self.imagePath = imagePath
        self.createdAt = createdAt ?? Date()
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
        addTransaction(amount: amount)
    }
    
    func removeBalance(amount: Double) {
        addTransaction(amount: amount, isAddition: false)
    }
    
    private func addTransaction(amount: Double, isAddition: Bool = true) {
        let transaction = Transaction(id: nil, savingsTarget: self, amount: amount, isAddition: isAddition, createdAt: nil)
        RealmService.shared.create(transaction)
    }
    
    private func removeTransaction(date: Date) {
        // TODO: Remove transaction
    }
    
}
