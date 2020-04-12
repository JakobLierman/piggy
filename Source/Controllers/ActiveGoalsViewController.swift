//
//  ActiveGoalsViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 08/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

class ActiveGoalsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 12
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @IBAction func addTarget(_ sender: Any) {
        let addGoalStoryboard: UIStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
        let addGoalInitialViewController = addGoalStoryboard.instantiateInitialViewController()!
        self.present(addGoalInitialViewController, animated: true, completion: nil) // TODO - Completion?
    }
}
