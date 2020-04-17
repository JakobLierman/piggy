//
//  AddGoalTableViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 13/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyPickerPopover

class AddGoalTableViewController: UITableViewController {

    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var amountToSaveTextField: UITextField!
    @IBOutlet weak var amountSavedTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var deadlineButton: UIButton!
    @IBOutlet weak var toSaveCurrencySymbol: UILabel!
    @IBOutlet weak var SavedCurrencySymbol: UILabel!

    let db = RealmService.shared
    var categories: Results<Category>!
    
    var goalName: String?
    var typedAmountToSave: Int = 0
    var typedAmountSaved: Int = 0
    var category: Category?
    var deadline: Date?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    convenience init(goalName: String, amountToSave: Double, amountSaved: Double?, category: Category?, deadLine: Date?) {
        self.init()
        self.goalName = goalName
        self.typedAmountToSave = Int(amountToSave * 100)
        self.typedAmountSaved = Int(amountSaved ?? 0 * 100)
        self.category = category
        self.deadline = deadline
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get all categories from db
        categories = db.realm.objects(Category.self)
        
        // Set fields
        self.goalNameTextField.text = self.goalName
        self.amountToSaveTextField.text = CurrencyConvert.shared.typedValueToCurrency(self.typedAmountToSave)
        self.amountSavedTextField.text = CurrencyConvert.shared.typedValueToCurrency(self.typedAmountSaved)
        self.amountToSaveTextField.delegate = self
        self.amountSavedTextField.delegate = self
        self.setSelectedCategory(self.category)
        self.setSelectedDeadline(self.deadline)
    }
    
    private func setSelectedCategory(_ selectedCategory: Category?) {
        self.category = selectedCategory
        
        self.categoryButton.setTitle((selectedCategory == nil) ? "None" : selectedCategory!.name, for: .normal)
    }
    
    private func setSelectedDeadline(_ selectedDate: Date?) {
        self.deadline = selectedDate
        
        self.deadlineButton.setTitle((selectedDate == nil) ? "None" : dateFormatter.string(from: self.deadline!), for: .normal)
    }
    
    @IBAction func showCategoryPickerPopover(_ sender: UIButton) {
        StringPickerPopover(title: "Category", choices: self.categories.map({ $0.name }))
            .setClearButton(action: { (popover, _, _) in
                self.setSelectedCategory(nil)
                popover.disappear()
            })
            .setDoneButton(action: { (_, selectedRow, _) in
                self.setSelectedCategory((selectedRow == 0) ? nil : self.categories[selectedRow-1])
            })
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func showDatePickerPopover(_ sender: UIButton) {
        DatePickerPopover(title: "Deadline")
            .setDateMode(.date)
            .setMinimumDate(Date())
            .setClearButton(action: { (popover, _) in
                self.setSelectedDeadline(nil)
                popover.disappear()
            })
            .setDoneButton(action: { (_, selectedDate) in self.setSelectedDeadline(selectedDate)})
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        do {
            let savingsTarget = try SavingsTarget(name: self.goalNameTextField.text ?? "", price: Double(self.typedAmountToSave / 100), balance: Double(self.typedAmountSaved / 100), category: self.category, deadline: self.deadline)
            db.create(savingsTarget)
            self.dismiss(animated: true, completion: nil)
        } catch SavingsTargetError.emptyNameError {
            self.showErrorAlert(title: "Name is missing", message: "Please add a name and try again.")
        } catch SavingsTargetError.noPriceError {
            self.showErrorAlert(title: "Price is missing", message: "Please add an amount to save bigger than 0 and try again.")
        } catch SavingsTargetError.dateToEarly(let earliestDate) {
            self.showErrorAlert(title: "Invalid deadline", message: "Please add a deadline after \(dateFormatter.string(from: earliestDate)) and try again.")
        } catch {
            self.showErrorAlert(title: "Something went wrong", message: "Unexpected error: \(error).")
            print("Unexpected error: \(error).")
        }
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor(named: "Primary")
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddGoalTableViewController: UITextFieldDelegate {
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textFieldToChange == amountToSaveTextField {
            if let digit = Int(string) {
                typedAmountToSave = typedAmountToSave * 10 + digit
            }
            if string == "" {
               typedAmountToSave = typedAmountToSave / 10
            }
            amountToSaveTextField.text = CurrencyConvert.shared.typedValueToCurrency(self.typedAmountToSave)
        } else if textFieldToChange == amountSavedTextField {
            if let digit = Int(string) {
                typedAmountSaved = typedAmountSaved * 10 + digit
            }
            if string == "" {
                typedAmountSaved = typedAmountSaved / 10
            }
            amountSavedTextField.text = CurrencyConvert.shared.typedValueToCurrency(self.typedAmountSaved)
        } else {
            return true
        }
        return false
    }
    
}
