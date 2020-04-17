//
//  SavingsTargetTableViewCell.swift
//  Piggy
//
//  Created by Jakob Lierman on 08/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

class SavingsTargetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel?
    @IBOutlet weak var balanceCheckmark: UIImageView?
    @IBOutlet weak var progressBarBackground: UIView!
    @IBOutlet weak var progressBarFill: UIView!
    
    func configure(with savingsTarget: SavingsTarget) {
        cellImage.image = UIImage(named: savingsTarget.category?.icon ?? "save-money")
        nameLabel.text = savingsTarget.name
        priceLabel.text = CurrencyConvert.shared.doubleToCurrency(savingsTarget.price)
        balanceLabel?.text = CurrencyConvert.shared.doubleToCurrency(savingsTarget.balance)

        let progressBarFillWidth = CGFloat(savingsTarget.balance / savingsTarget.price) * progressBarBackground.frame.width
        progressBarFill.frame = CGRect(x: 0, y: 0, width: progressBarFillWidth, height: progressBarFill.frame.height)
        progressBarBackground.layer.cornerRadius = progressBarBackground.frame.height / 2.0
        progressBarFill.layer.cornerRadius = progressBarFill.frame.height / 2.0
    }
    
}
