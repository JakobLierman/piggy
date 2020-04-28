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
    @IBOutlet weak var ofLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceCheckmark: UIImageView!
    @IBOutlet weak var progressBarBackground: UIView!
    @IBOutlet weak var progressBarFill: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with savingsTarget: SavingsTarget) {
        cellImage.image = UIImage(named: savingsTarget.category?.icon ?? "save-money")
        nameLabel.text = savingsTarget.name
        priceLabel.text = CurrencyConvert.doubleToCurrency(savingsTarget.price)
        if (savingsTarget.price > savingsTarget.balance) {
            balanceLabel.text = CurrencyConvert.doubleToCurrency(savingsTarget.balance)
            balanceCheckmark.isHidden = true
        } else {
            ofLabel.isHidden = true
            balanceLabel.isHidden = true
        }

        progressBarFill.widthAnchor.constraint(equalTo: progressBarFill.superview!.widthAnchor, multiplier: CGFloat(savingsTarget.balance / savingsTarget.price)).isActive = true
        progressBarBackground.layer.cornerRadius = progressBarBackground.frame.height / 2.0
        progressBarFill.layer.cornerRadius = progressBarFill.frame.height / 2.0
    }
    
}
