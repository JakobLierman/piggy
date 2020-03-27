//
//  SavingsTarget.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

struct SavingsTarget {
    
    // MARK: Properties
    var name: String
    var price: Double
    var balance: Double?
    var category: String? // TODO: Category
    var deadline: Date?
    var imagePath: String?
    var transactions: [Date: Transaction] = [:]
    let timeCreated: Date = Date()
    
    // MARK: Constructors
    
    // MARK: Functions
    func getRemainingTime() -> Double {
        return deadline!.timeIntervalSinceNow
    }
    
    func addBalance(amount: Double) {
        self.addTransaction(amount: amount)
    }
    
    func removeBalance(amount: Double) {
        self.addTransaction(amount: amount, isAddition: false)
    }
    
    private func addTransaction(amount: Double, isAddition: Bool = true) {
        // TODO
    }
    
    private func removeTransaction(date: Date) {
        // TODO: Remove transaction
    }
    
}
