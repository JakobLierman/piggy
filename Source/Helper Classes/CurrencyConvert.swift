//
//  CurrencyConvert.swift
//  Piggy
//
//  Created by Jakob Lierman on 15/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

class CurrencyConvert {
    
    private static func currencyStringToFormatter(_ currency: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        switch currency {
            case "EUR":
                formatter.locale = Locale.init(identifier: "nl_BE")
                break
            case "USD":
                formatter.locale = Locale.init(identifier: "en_US")
                break
            case "GBP":
                formatter.locale = Locale.init(identifier: "en_GB")
                break
            default:
                formatter.locale = Locale.init(identifier: "nl_BE")
        }
        return formatter
    }
    
    static func doubleToCurrency(_ amount: Double) -> String {
        let formatter = self.currencyStringToFormatter(User.currentUser().currency)
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    static func currencyToDouble(_ input: String) -> Double? {
        let formatter = self.currencyStringToFormatter(User.currentUser().currency)
        return formatter.number(from: input)?.doubleValue
    }
    
    static func typedValueToCurrency(_ typedAmount: Int) -> String? {
        let amount = Double(typedAmount / 100) + Double(typedAmount % 100) / 100
        let formatter = self.currencyStringToFormatter(User.currentUser().currency)
        return formatter.string(from: NSNumber(value: amount))
    }
}
