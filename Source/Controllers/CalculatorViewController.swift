//
//  CalculatorViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 29/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import MaterialShowcase

class CalculatorViewController: UIViewController {
    
    private let tintColor = UIColor(named: "Primary")!
    
    var showcaseSequence = MaterialShowcaseSequence()
    
    var typedAmountToSave: Int = 0
    var typedDailySavings: Int = 0
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    lazy var segmentedControlShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.segmentedControl)
        showcase.primaryText = "What to calculate?"
        showcase.secondaryText = "Do you want to calculate the amount you need to save daily to reach your deadline or when you will reach your target when putting aside some money every day?"
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var amountToSaveTextFieldShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.amountToSaveTextField)
        showcase.primaryText = "Amount To Save"
        showcase.secondaryText = "The goal is 350.00? Add it here."
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var secundaryContainerShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.deadlineContainer)
        showcase.primaryText = "Deadline or daily savings"
        showcase.secondaryText = "Add your deadline or the amount you can put aside every day."
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var resultContainerShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.resultContainer)
        showcase.primaryText = "Result"
        showcase.secondaryText = "Calculations complete! 🎉"
        showcase.primaryTextAlignment = .center
        showcase.secondaryTextAlignment = .center
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var amountToSaveContainer: UIStackView!
    @IBOutlet weak var amountToSaveTextField: UITextField!
    @IBOutlet weak var dailySavingsContainer: UIStackView!
    @IBOutlet weak var dailySavingsTextField: UITextField!
    @IBOutlet weak var deadlineContainer: UIStackView!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var resultContainer: UIStackView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.alwaysBounceVertical = true
        self.amountToSaveTextField.delegate = self
        self.dailySavingsTextField.delegate = self
        self.updateView()
        
        if !Onboarding.usesOnboardingAndHelp {
            self.helpBarButton.hide()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteCalculatorShowcase {
            showCalculatorShowcase()
        }
    }
    
    func showCalculatorShowcase() {
        showcaseSequence.temp(segmentedControlShowcase)
            .temp(amountToSaveTextFieldShowcase)
            .temp(secundaryContainerShowcase)
            .temp(resultContainerShowcase)
            .start()
        
        Onboarding.userDidCompleteCalculatorShowcase = true
    }
    
    private func updateView() {
        dailySavingsContainer.isHidden = segmentedControl.selectedSegmentIndex == 0
        deadlineContainer.isHidden = segmentedControl.selectedSegmentIndex == 1
        
        self.amountToSaveTextField.text = Currency.typedValueToCurrency(self.typedAmountToSave)
        self.dailySavingsTextField.text = Currency.typedValueToCurrency(self.typedDailySavings)
        deadlineDatePicker.minimumDate = Date()
    }

    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        self.updateView()
        self.updateResult(sender)
    }
    
    @IBAction func updateResult(_ sender: Any) {
        guard typedAmountToSave > 0 else {
            return resultLabel.text = "--"
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            guard deadlineDatePicker.date > Date() else {
                return resultLabel.text = "--"
            }
            
            let today = Calendar.current.startOfDay(for: Date())
            let deadline = Calendar.current.startOfDay(for: deadlineDatePicker.date)
            let amountDays = Calendar.current.dateComponents([.day], from: today, to: deadline).day!
            let resultValue: Int = Int(Double(typedAmountToSave / amountDays).rounded(.up))
            resultLabel.text = Currency.typedValueToCurrency(resultValue)
            resultLabel.text! += " per day"
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            guard typedAmountToSave > typedDailySavings && typedDailySavings > 0 else {
                return resultLabel.text = "--"
            }

            var dateComponent = DateComponents()
            let amountDays: Int = Int(Double(typedAmountToSave / typedDailySavings).rounded(.up))
            dateComponent.day = amountDays
            let resultValue: Date = Calendar.current.date(byAdding: dateComponent, to: Date())!
            resultLabel.text = dateFormatter.string(from: resultValue)
            
        } else {
            return resultLabel.text = "--"
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        typedAmountToSave = 0
        typedDailySavings = 0
        deadlineDatePicker.date = Date()
        self.updateView()
        self.updateResult(sender)
    }
    
    @IBAction private func openSettingsTapped(_ sender: UIBarButtonItem) {
        let settingsController = SettingsController()
        self.presentAsLark(settingsController)
    }
    
    @IBAction private func helpTapped(_ sender: UIBarButtonItem) {
        showCalculatorShowcase()
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textFieldToChange == amountToSaveTextField {
            if let digit = Int(string) {
                typedAmountToSave = typedAmountToSave * 10 + digit
            }
            if string == "" {
                typedAmountToSave = typedAmountToSave / 10
            }
            amountToSaveTextField.text = Currency.typedValueToCurrency(self.typedAmountToSave)
        } else if textFieldToChange == dailySavingsTextField {
            if let digit = Int(string) {
                typedDailySavings = typedDailySavings * 10 + digit
            }
            if string == "" {
                typedDailySavings = typedDailySavings / 10
            }
            dailySavingsTextField.text = Currency.typedValueToCurrency(self.typedDailySavings)
        } else {
            return true
        }
        
        self.updateResult(textFieldToChange)
        return false
    }
    
}

extension CalculatorViewController: MaterialShowcaseDelegate {
  func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
    showcaseSequence.showCaseWillDismis()
  }
}
