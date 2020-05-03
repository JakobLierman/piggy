//
//  GoalDetailsViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 18/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SPAlert

class GoalDetailsViewController: UIViewController {
    
    var savingsTarget: SavingsTarget!
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var imageEffect: UIVisualEffectView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addBalanceContainer: UIView!
    @IBOutlet weak var addBalanceValueLabel: UILabel!
    @IBOutlet weak var addBalanceSlider: UISlider!
    @IBOutlet weak var quickAddMinimumLabel: UILabel!
    @IBOutlet weak var quickAddMaximumLabel: UILabel!
    @IBOutlet weak var goalReachedContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2.0
        balanceLabel.layer.cornerRadius = 8
        priceLabel.layer.cornerRadius = 8
        addBalanceContainer.layer.cornerRadius = 20
        addBalanceValueLabel.layer.cornerRadius = 8
        goalReachedContainer.layer.cornerRadius = 20
        
        self.loadValues()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.alwaysBounceVertical = true
    }
    
    private func loadValues() {
        self.title = savingsTarget.name
        
        if savingsTarget.deadline != nil {
            self.navigationItem.prompt = "Deadline: " + dateFormatter.string(from: (savingsTarget.deadline)!)
        }
        
        imageView.image = UIImage(named: savingsTarget.category?.icon ?? "save-money")
        
        balanceLabel.text = CurrencyConvert.doubleToCurrency(savingsTarget.balance)
        priceLabel.text = CurrencyConvert.doubleToCurrency(savingsTarget.price)
        
        let completePercentage = savingsTarget.balance / savingsTarget.price
        imageBackground.heightAnchor.constraint(equalTo: imageBackground.superview!.heightAnchor, multiplier: CGFloat(completePercentage)).isActive = true
        percentageLabel.text = "\(round(completePercentage * 100)) %"
        
        var quickAddMinimumValue = 5.0
        var quickAddMaximumValue = 50.0
        if ((self.savingsTarget.price - self.savingsTarget.balance) < 50) {
            quickAddMinimumValue = 1.0
            quickAddMaximumValue = self.savingsTarget.price - self.savingsTarget.balance
        }
        addBalanceSlider.minimumValue = Float(quickAddMinimumValue)
        addBalanceSlider.maximumValue = Float(quickAddMaximumValue)
        addBalanceSlider.value = addBalanceSlider.minimumValue
        addBalanceValueLabel.text = CurrencyConvert.doubleToCurrency(quickAddMinimumValue)
        quickAddMinimumLabel.text = CurrencyConvert.doubleToCurrency(quickAddMinimumValue)
        quickAddMaximumLabel.text = CurrencyConvert.doubleToCurrency(quickAddMaximumValue)
        
        addBalanceContainer.isHidden = completePercentage == 1.0
        goalReachedContainer.isHidden = completePercentage != 1.0
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let x = Double(round(sender.value))
        addBalanceValueLabel.text = CurrencyConvert.doubleToCurrency(x)
        // TODO: Move label
    }
    
    @IBAction func quickAddTapped(_ sender: UIControl) {
        self.savingsTarget.addBalance(Double(round(addBalanceSlider.value)))
        self.loadValues()
        SPAlert.present(title: "Balance Added", preset: .done)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func advancedAddTapped(_ sender: UIControl) {
        let advancedAddAmountNavigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedAdd") as! UINavigationController
        advancedAddAmountNavigationViewController.modalPresentationStyle = .popover
        
        let advancedAddAmountViewController = advancedAddAmountNavigationViewController.viewControllers.first as! AdvancedAddAmountViewController
        advancedAddAmountViewController.savingsTarget = self.savingsTarget
        
        self.present(advancedAddAmountNavigationViewController, animated: true)
    }
    
}
