//
//  User.swift
//  Piggy
//
//  Created by Jakob Lierman on 27/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import SwiftHash

struct User {
    
    // MARK: Properties
    var name: String
    var currency: Currency
    var passwordHash: String?
    
    // MARK: Constructors
    init(name: String, currency: Currency, password: String?) {
        self.name = name
        self.currency = currency
        setPassword(password: password)
    }
    
    // MARK: Functions
    mutating func setPassword(password: String?) {
        if (password == nil) {
            self.passwordHash = nil
        } else {
            self.passwordHash = MD5(password!)
        }
    }
    
    func passwordCheck(password: String) -> Bool {
        return MD5(password) == passwordHash
    }

}

enum Currency {
    case eur
    case usd
    case gbp
}
