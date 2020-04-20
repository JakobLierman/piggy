//
//  GoalDetailsViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 18/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {
    
    var savingsTarget: SavingsTarget!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageContainer.layer.cornerRadius = imageContainer.frame.width / 2.0
        balanceLabel.layer.cornerRadius = 8
        priceLabel.layer.cornerRadius = 8
        addBalanceContainer.layer.cornerRadius = 20
        addBalanceValueLabel.layer.cornerRadius = 8
        
        self.title = savingsTarget.name
        
        imageView.image = UIImage(named: savingsTarget.category?.icon ?? "save-money")
        
        balanceLabel.text = CurrencyConvert.shared.doubleToCurrency(savingsTarget.balance)
        priceLabel.text = CurrencyConvert.shared.doubleToCurrency(savingsTarget.price)
        
        let quickAddMinimumValue = 5.0
        let quickAddMaximumValue = 50.0
        addBalanceSlider.minimumValue = Float(quickAddMinimumValue)
        addBalanceSlider.maximumValue = Float(quickAddMaximumValue)
        addBalanceSlider.value = addBalanceSlider.minimumValue
        addBalanceValueLabel.text = CurrencyConvert.shared.doubleToCurrency(quickAddMinimumValue)
        quickAddMinimumLabel.text = CurrencyConvert.shared.doubleToCurrency(quickAddMinimumValue)
        quickAddMaximumLabel.text = CurrencyConvert.shared.doubleToCurrency(quickAddMaximumValue)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let x = Double(round(sender.value))
        addBalanceValueLabel.text = CurrencyConvert.shared.doubleToCurrency(x)
        // TODO: Move label
    }
    
    @IBAction func quickAddTapped(_ sender: UIControl) {
        // TODO: Quick add functionality
    }
    
    @IBAction func advancedAddTapped(_ sender: UIControl) {
        // TODO: Advanced add functionality
    }
    
}
