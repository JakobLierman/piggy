//
//  SavingsTargetsTableViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 08/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import RealmSwift
import TORoundedButton

class SavingsTargetsTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    let db = RealmService.shared
    var savingsTargets: Results<SavingsTarget>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Dynamic filter
        savingsTargets = db.realm.objects(SavingsTarget.self).filter("price > balance")
        
        table.delegate = self
        table.dataSource = self
        
        self.registerTableViewCells()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savingsTargets.count == 0 {
            tableView.setEmptyView(title: "You do not have any active goals", message: "Create one with the button above")
        } else {
            tableView.restore()
        }

        return savingsTargets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsTargetCell") as? SavingsTargetTableViewCell else { return UITableViewCell() }
        
        let savingsTarget = savingsTargets[indexPath.row]
        cell.configure(with: savingsTarget)
        
        return cell
    }
    
    private func registerTableViewCells() {
        let SavingsTargetCell = UINib(nibName: "SavingsTargetTableViewCell",
                                  bundle: nil)
        self.tableView.register(SavingsTargetCell,
                                forCellReuseIdentifier: "SavingsTargetCell")
    }

    @IBAction func addTarget(_ sender: RoundedButton) {
        let addGoalStoryboard: UIStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
        let addGoalInitialViewController = addGoalStoryboard.instantiateInitialViewController()!
        self.present(addGoalInitialViewController, animated: true, completion: nil) // TODO - Completion?
    }
    
    @IBAction func openSettings(_ sender: UIBarButtonItem) {
        // TODO: Open settings panel on tap
    }
}
