//
//  AdvancedAddAmountViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 03/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SPAlert

class AdvancedAddAmountViewController: UITableViewController {
    
    var savingsTarget: SavingsTarget!
    
    var typedAmount: Int = 0
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var isRemovalSwitch: UISwitch!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var newBalanceLabel: UILabel!
    @IBOutlet weak var balanceDifferenceLabel: UILabel!
    @IBOutlet weak var oldBalanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        
        self.oldBalanceLabel.text = Currency.doubleToCurrency(savingsTarget.balance)
        self.priceLabel.text = Currency.doubleToCurrency(savingsTarget.price)
        
        self.newBalanceLabel.text = "--"
        self.balanceDifferenceLabel.text = "--"
    }
    
    @IBAction func updateBalance(_ sender: Any) {
        var balance: Double = 0.0
        
        if self.isRemovalSwitch.isOn {
            balanceDifferenceLabel.textColor = .systemRed
            balanceDifferenceLabel.text = "- "
            
            balance = savingsTarget.balance - Double(self.typedAmount) / 100
            if balance < 0.0 {
                balance = 0.0
            }
        } else {
            balanceDifferenceLabel.textColor = .systemGreen
            balanceDifferenceLabel.text = "+ "
            
            balance = savingsTarget.balance + Double(self.typedAmount) / 100
            if balance > savingsTarget.price {
                balance = savingsTarget.price
            }
        }
        
        self.balanceDifferenceLabel.text! += Currency.typedValueToCurrency(typedAmount) ?? "--"
        self.newBalanceLabel.text = Currency.doubleToCurrency(balance)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if typedAmount == 0 {
            SPAlert.showErrorAlert(title: "Could not add balance", message: "Amount must be different from zero.")
        }
        
        if isRemovalSwitch.isOn {
            self.savingsTarget.removeBalance(Double(self.typedAmount) / 100)
        } else {
            self.savingsTarget.addBalance(Double(self.typedAmount) / 100)
        }
        
        SPAlert.present(title: "Balance Added", preset: .done)
        self.dismiss(animated: true, completion: nil)
    }

}

extension AdvancedAddAmountViewController: UITextFieldDelegate {
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textFieldToChange == amountTextField {
            if let digit = Int(string) {
                typedAmount = typedAmount * 10 + digit
            }
            if string == "" {
                typedAmount = typedAmount / 10
            }
            amountTextField.text = Currency.typedValueToCurrency(self.typedAmount)
        } else {
            return true
        }
        
        self.updateBalance(textFieldToChange)
        return false
    }
    
}
