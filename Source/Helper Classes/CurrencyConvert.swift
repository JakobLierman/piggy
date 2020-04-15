//
//  CurrencyConvert.swift
//  Piggy
//
//  Created by Jakob Lierman on 15/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

class CurrencyConvert {
    
    private init() {}
    static let shared = CurrencyConvert()
    
    func doubleToCurrency(_ amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func currencyToDouble(_ input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func typedValueToCurrency(_ typedAmount: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let amount = Double(typedAmount / 100) + Double(typedAmount % 100) / 100
        return formatter.string(from: NSNumber(value: amount))
    }
}
