//
//  SavingsTargetsTableViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 08/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import RealmSwift

class SavingsTargetsTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    let db = RealmService.shared
    var savingsTargets: Results<SavingsTarget>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savingsTargets = db.realm.objects(SavingsTarget.self).filter("price > balance")
        
        //savingsTargets.append(SavingsTarget.init(name: "Mac Pro", price: 30000))
        
        table.delegate = self
        table.dataSource = self
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
    
}
