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
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSavingsTargets: [SavingsTarget] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var addTargetButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savingsTargets = db.realm.objects(SavingsTarget.self).filter((self.storyboard!.value(forKey: "name") as! String).starts(with: "Active") ? "price > balance" : "price == balance")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.registerTableViewCells()
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Goals"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
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
        
        if isFiltering {
            return filteredSavingsTargets.count
        }

        return savingsTargets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsTargetCell") as? SavingsTargetTableViewCell else { return UITableViewCell() }
        
        let savingsTarget: SavingsTarget
        if isFiltering {
            savingsTarget = filteredSavingsTargets[(filteredSavingsTargets.count - 1) - indexPath.row]
        } else {
            savingsTarget = savingsTargets[(savingsTargets.count - 1) - indexPath.row]
        }
        
        cell.configure(with: savingsTarget)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notificationToken?.invalidate()
            
            let savingsTarget: SavingsTarget
            if isFiltering {
                savingsTarget = filteredSavingsTargets[(filteredSavingsTargets.count - 1) - indexPath.row]
            } else {
                savingsTarget = savingsTargets[(savingsTargets.count - 1) - indexPath.row]
            }
            
            self.db.delete(savingsTarget)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.reloadData()
            
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
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSavingsTargets = savingsTargets.filter { (savingsTarget: SavingsTarget) -> Bool in
            let containsInName = savingsTarget.name.lowercased().contains(searchText.lowercased())
            let containsInCategoryName = savingsTarget.category?.name.lowercased().contains(searchText.lowercased()) ?? false
            return containsInName || containsInCategoryName
        }
        
        tableView.reloadData()
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

extension SavingsTargetsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension SavingsTargetsTableViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        self.addTargetButton.setHidden(true)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.addTargetButton.setHidden(false)
    }
}

extension RoundedButton {
    func setHidden(_ hidden: Bool) {
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
            // TODO: Completely remove item
            //self.isHidden = hidden
        })
    }
}
