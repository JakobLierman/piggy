//
//  Transaction.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

struct Transaction {
    
    // MARK: Properties
    let savingsTarget: SavingsTarget
    var amount: Double
    var isAddition: Bool = true
    let timeCreated: Date = Date()
    
}
