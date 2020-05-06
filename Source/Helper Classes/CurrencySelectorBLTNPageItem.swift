//
//  CurrencySelectorBLTNPageItem.swift
//  Piggy
//
//  Created by Jakob Lierman on 06/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import BLTNBoard

class CurrencySelectorBLTNPageItem: BLTNPageItem {
    
    private var eurButtonContainer: UIButton!
    private var usdButtonContainer: UIButton!
    private var gbpButtonContainer: UIButton!
    
    override func tearDown() {
        eurButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        usdButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        gbpButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        let selectedCurrency = User.currentUser().currency
        
        let currenciesStack = interfaceBuilder.makeGroupStack(spacing: 16)
        
        let eurButtonContainer = createChoiceCell(currency: .eur, isSelected: selectedCurrency == CurrencyEnum.eur.rawValue)
        eurButtonContainer.addTarget(self, action: #selector(eurButtonTapped), for: .touchUpInside)
        currenciesStack.addArrangedSubview(eurButtonContainer)
        self.eurButtonContainer = eurButtonContainer
        
        let usdButtonContainer = createChoiceCell(currency: .usd, isSelected: selectedCurrency == CurrencyEnum.usd.rawValue)
        usdButtonContainer.addTarget(self, action: #selector(usdButtonTapped), for: .touchUpInside)
        currenciesStack.addArrangedSubview(usdButtonContainer)
        self.usdButtonContainer = usdButtonContainer
        
        let gbpButtonContainer = createChoiceCell(currency: .gbp, isSelected: selectedCurrency == CurrencyEnum.gbp.rawValue)
        gbpButtonContainer.addTarget(self, action: #selector(gbpButtonTapped), for: .touchUpInside)
        currenciesStack.addArrangedSubview(gbpButtonContainer)
        self.gbpButtonContainer = gbpButtonContainer
        
        return [currenciesStack]
        
    }
    
    private func createChoiceCell(currency: CurrencyEnum, isSelected: Bool) -> UIButton {

        let symbol: String
        let name: String = currency.rawValue

        switch currency {
            case .eur:
                symbol = "€"
            case .usd:
                symbol = "$"
            case .gbp:
                symbol = "£"
        }

        let button = UIButton(type: .system)
        button.setTitle(symbol + " " + name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        button.accessibilityLabel = name

        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }

        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2

        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor

        if isSelected {
            // TODO: Set currency ???
        }

        return button

    }
    
    @objc func eurButtonTapped() {
        
        User.currentUser().updateCurrency("EUR")
        
        let selectedColor = appearance.actionButtonColor
        let unselectedColor = UIColor.lightGray
        
        eurButtonContainer?.layer.borderColor = selectedColor.cgColor
        eurButtonContainer?.setTitleColor(selectedColor, for: .normal)
        eurButtonContainer?.accessibilityTraits.insert(.selected)

        usdButtonContainer?.layer.borderColor = unselectedColor.cgColor
        usdButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        usdButtonContainer?.accessibilityTraits.remove(.selected)

        gbpButtonContainer?.layer.borderColor = unselectedColor.cgColor
        gbpButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        gbpButtonContainer?.accessibilityTraits.remove(.selected)
        
    }
    
    @objc func usdButtonTapped() {
        
        User.currentUser().updateCurrency("USD")

        let selectedColor = appearance.actionButtonColor
        let unselectedColor = UIColor.lightGray
        
        eurButtonContainer?.layer.borderColor = unselectedColor.cgColor
        eurButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        eurButtonContainer?.accessibilityTraits.remove(.selected)

        usdButtonContainer?.layer.borderColor = selectedColor.cgColor
        usdButtonContainer?.setTitleColor(selectedColor, for: .normal)
        usdButtonContainer?.accessibilityTraits.insert(.selected)

        gbpButtonContainer?.layer.borderColor = unselectedColor.cgColor
        gbpButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        gbpButtonContainer?.accessibilityTraits.remove(.selected)
        
    }
    
    @objc func gbpButtonTapped() {
        
        User.currentUser().updateCurrency("GBP")

        let selectedColor = appearance.actionButtonColor
        let unselectedColor = UIColor.lightGray
        
        eurButtonContainer?.layer.borderColor = unselectedColor.cgColor
        eurButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        eurButtonContainer?.accessibilityTraits.remove(.selected)

        usdButtonContainer?.layer.borderColor = unselectedColor.cgColor
        usdButtonContainer?.setTitleColor(unselectedColor, for: .normal)
        usdButtonContainer?.accessibilityTraits.remove(.selected)

        gbpButtonContainer?.layer.borderColor = selectedColor.cgColor
        gbpButtonContainer?.setTitleColor(selectedColor, for: .normal)
        gbpButtonContainer?.accessibilityTraits.insert(.selected)
        
    }

}
