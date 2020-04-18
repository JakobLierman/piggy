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
    
    let db = RealmService.shared
    var savingsTargets: Results<SavingsTarget>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savingsTargets = db.realm.objects(SavingsTarget.self).filter((self.storyboard!.value(forKey: "name") as! String).starts(with: "Active") ? "price > balance" : "price == balance")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.notificationToken = db.realm.observe { notification, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.notificationToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savingsTargets.isEmpty {
            tableView.setEmptyView(title: "You do not have any active goals", message: "Create one with the button above")
        } else {
            tableView.restore()
        }

        return savingsTargets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsTargetCell") as? SavingsTargetTableViewCell else { return UITableViewCell() }
        
        let savingsTarget = savingsTargets[(savingsTargets.count - 1) - indexPath.row]
        cell.configure(with: savingsTarget)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notificationToken?.invalidate()
            
            if let savingsTarget = savingsTargets?[(savingsTargets.count - 1) - indexPath.row] {
                self.db.delete(savingsTarget)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            self.notificationToken = self.db.realm.observe { notification, realm in
                self.tableView.reloadData()
            }
        }
    }
    
    private func registerTableViewCells() {
        let SavingsTargetCell = UINib(nibName: "SavingsTargetTableViewCell",
                                  bundle: nil)
        tableView.register(SavingsTargetCell,
                                forCellReuseIdentifier: "SavingsTargetCell")
    }
    
    func addTarget(_ savingsTarget: SavingsTarget) {
        db.create(savingsTarget)
    }

    @IBAction private func addTargetTapped(_ sender: RoundedButton) {
        let addGoalStoryboard: UIStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
        let addGoalInitialViewController = addGoalStoryboard.instantiateInitialViewController()!
        self.present(addGoalInitialViewController, animated: true, completion: nil)
    }
    
    @IBAction private func openSettingsTapped(_ sender: UIBarButtonItem) {
        // TODO: Open settings panel on tap
    }
}
