//
//  ActiveGoalsTableViewCell.swift
//  Piggy
//
//  Created by Jakob Lierman on 08/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

class ActiveGoalsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var savedAmountLabel: UILabel!
    @IBOutlet weak var goalAmountLabel: UILabel!
    @IBOutlet weak var progressBarBackground: UIView!
    @IBOutlet weak var progressBarFill: UIView!
    
    func configure(with savingsTarget: SavingsTarget) {
        cellImage.image = #imageLiteral(resourceName: "daily-savings-calc") // TODO
        nameLabel.text = savingsTarget.name
        savedAmountLabel.text = String(savingsTarget.balance ?? 0.00)
        goalAmountLabel.text = String(savingsTarget.price)
        
        let progressBarFillWidth = CGFloat((savingsTarget.balance ?? 0.00) / savingsTarget.price) * progressBarBackground.frame.width
        progressBarFill.frame = CGRect(x: 0, y: 0, width: progressBarFillWidth, height: progressBarFill.frame.height) // TODO
        
        progressBarBackground.layer.cornerRadius = progressBarBackground.frame.height / 2.0
        progressBarFill.layer.cornerRadius = progressBarFill.frame.height / 2.0
    }
    
}
