//
//  GoalDetailsViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 18/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SPAlert
import MaterialShowcase

class GoalDetailsViewController: UIViewController {
    
    private let tintColor = UIColor(named: "Secondary")!
    
    var savingsTarget: SavingsTarget!
    var showcaseSequence = MaterialShowcaseSequence()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    lazy var imageContainerShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.imageContainer)
        showcase.primaryText = "Your progress"
        showcase.secondaryText = "The more you save, the more the background fills!"
        showcase.primaryTextAlignment = .center
        showcase.secondaryTextAlignment = .center
        showcase.targetHolderColor = .clear
        showcase.targetHolderRadius = imageContainer.frame.size.height / 2.0
        showcase.backgroundRadius = imageContainer.frame.size.height
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var addBalanceContainerShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.addBalanceContainer)
        showcase.primaryText = "Add Balance"
        showcase.secondaryText = "Saved some 💰? Add it in the app!"
        showcase.targetHolderColor = .clear
        showcase.targetHolderRadius = addBalanceContainer.frame.size.height / 2.0
        showcase.delegate = self
        return showcase
    }()
    lazy var advancedAddButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: self.advancedAddButton)
        showcase.primaryText = "Advanced Add Balance"
        showcase.secondaryText = "You can add or remove as much balance as you want. This button gives you more options."
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
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
    @IBOutlet weak var advancedAddButton: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteDetailsShowcase {
            showDetailsShowcase()
        }
    }
    
    override func viewDidLayoutSubviews() {
        imageContainer.layer.cornerRadius = imageContainer.frame.size.height / 2.0
        balanceLabel.layer.cornerRadius = 8
        priceLabel.layer.cornerRadius = 8
        addBalanceContainer.layer.cornerRadius = 20
        addBalanceValueLabel.layer.cornerRadius = 8
        goalReachedContainer.layer.cornerRadius = 20
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: stackView.frame.height + 24.0)
        scrollView.alwaysBounceVertical = true
    }
    
    func showDetailsShowcase() {
        showcaseSequence
            .temp(imageContainerShowcase)
            .temp(addBalanceContainerShowcase)
            .temp(advancedAddButtonShowcase)
            .start()
        
        Onboarding.userDidCompleteDetailsShowcase = true
    }
    
    private func loadValues() {
        self.title = savingsTarget.name
        
        if savingsTarget.deadline != nil {
            self.navigationItem.prompt = "Deadline: " + dateFormatter.string(from: (savingsTarget.deadline)!)
        }
        
        imageView.image = UIImage(named: savingsTarget.category?.icon ?? "save-money")
        
        balanceLabel.text = Currency.doubleToCurrency(savingsTarget.balance)
        priceLabel.text = Currency.doubleToCurrency(savingsTarget.price)
        
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
        addBalanceValueLabel.text = Currency.doubleToCurrency(quickAddMinimumValue)
        quickAddMinimumLabel.text = Currency.doubleToCurrency(quickAddMinimumValue)
        quickAddMaximumLabel.text = Currency.doubleToCurrency(quickAddMaximumValue)
        
        addBalanceContainer.isHidden = completePercentage == 1.0
        goalReachedContainer.isHidden = completePercentage != 1.0
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let x = Double(round(sender.value))
        addBalanceValueLabel.text = Currency.doubleToCurrency(x)
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

extension GoalDetailsViewController: MaterialShowcaseDelegate {
  func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
    showcaseSequence.showCaseWillDismis()
  }
}
