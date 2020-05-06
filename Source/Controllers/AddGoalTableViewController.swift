//
//  AddGoalTableViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 13/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import RealmSwift
import SPAlert

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
        self.amountToSaveTextField.text = Currency.typedValueToCurrency(self.typedAmountToSave)
        self.amountSavedTextField.text = Currency.typedValueToCurrency(self.typedAmountSaved)
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
    
    @IBAction func showCategoryPicker(_ sender: UIButton) {
        let alert = UIAlertController(title: "Category", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Primary")
        for category: Category in self.categories {
            let action = UIAlertAction(title: category.name, style: .default, handler: { _ in
                self.setSelectedCategory(category)
            })
            action.setValue(self.category == category, forKey: "checked")
            /* TODO: Add image (correct size)
            if (category.icon != nil) {
                let image = UIImage(named: category.icon!)?.withRenderingMode(.alwaysOriginal)
                action.setValue(image, forKey: "image")
            }*/
            alert.addAction(action)
        }
        let clearAction = UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            self.setSelectedCategory(nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showDatePicker(_ sender: UIButton) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = self.deadline ?? Date()
        datePicker.minimumDate = Date()
        datePicker.timeZone = .current
        datePicker.frame = CGRect(x: 0, y: 32, width: (self.view.window?.frame.width)! - 16, height: 200)
        
        let alert = UIAlertController(title: "Deadline", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Primary")
        alert.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.setSelectedDeadline(datePicker.date)
        })
        let clearAction = UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            self.setSelectedDeadline(nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(selectAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        do {
            let savingsTarget = try SavingsTarget(name: self.goalNameTextField.text ?? "", price: Double(self.typedAmountToSave) / 100, balance: Double(self.typedAmountSaved) / 100, category: self.category, deadline: self.deadline)
            db.create(savingsTarget)
            SPAlert.present(title: "Goal Added", preset: .done)
            self.dismiss(animated: true, completion: nil)
        } catch SavingsTargetError.emptyNameError {
            SPAlert.showErrorAlert(title: "Name is missing", message: "Please add a name and try again.")
        } catch SavingsTargetError.noPriceError {
            SPAlert.showErrorAlert(title: "Price is missing", message: "Please add an amount to save bigger than 0 and try again.")
        } catch SavingsTargetError.balanceError(let maxBalance) {
            SPAlert.showErrorAlert(title: "You've alreade save too much", message: "Please add a balance smaller than \(maxBalance) and try again.")
        } catch SavingsTargetError.dateToEarly(let earliestDate) {
            SPAlert.showErrorAlert(title: "Invalid deadline", message: "Please add a deadline after \(dateFormatter.string(from: earliestDate)) and try again.")
        } catch {
            SPAlert.showErrorAlert(title: "Something went wrong", message: "Unexpected error: \(error).")
            print("Unexpected error: \(error).")
        }
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
            amountToSaveTextField.text = Currency.typedValueToCurrency(self.typedAmountToSave)
        } else if textFieldToChange == amountSavedTextField {
            if let digit = Int(string) {
                typedAmountSaved = typedAmountSaved * 10 + digit
            }
            if string == "" {
                typedAmountSaved = typedAmountSaved / 10
            }
            amountSavedTextField.text = Currency.typedValueToCurrency(self.typedAmountSaved)
        } else {
            return true
        }
        return false
    }
    
}
