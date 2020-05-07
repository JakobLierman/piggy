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
import SPLarkController
import BLTNBoard
import MaterialShowcase

class SavingsTargetsTableViewController: UITableViewController {
    
    private let tintColor = UIColor(named: "Primary")!
    
    let db = RealmService.shared
    var savingsTargets: Results<SavingsTarget>!
    var notificationToken: NotificationToken?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSavingsTargets: [SavingsTarget] = []
    var showcaseSequence = MaterialShowcaseSequence()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    lazy var onboardingBulletinManager: BLTNItemManager = {
        let bulletinManager = BLTNItemManager(rootItem: Onboarding.makeWelcomePage())
        bulletinManager.backgroundViewStyle = traitCollection.userInterfaceStyle == .light ? .blurredLight : .blurredDark
        return bulletinManager
    }()
    
    @IBOutlet weak var addTargetButton: RoundedButton!
    @IBOutlet weak var openSettingsBarButton: UIBarButtonItem!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    
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
        
        if !Onboarding.userDidCompleteGeneralOnboarding {
            onboardingBulletinManager.showBulletin(above: self)
        }
        
        self.notificationToken = db.realm.observe { notification, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
        
        if !Onboarding.userDidCompleteNavigationShowcase {
            showNavigationShowcase()
        }
        
        if !Onboarding.userDidCompleteTableShowcase {
            showTableShowcase()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.notificationToken?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savingsTargets.isEmpty {
            if (self.storyboard!.value(forKey: "name") as! String).starts(with: "Active") {
                tableView.setEmptyView(title: "You do not have any active goals", message: "Create one with the button above")
            } else {
                tableView.setEmptyView(title: "You do not have any finished goals", message: "Start saving!")
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowItem = savingsTargets?[(savingsTargets.count - 1) - indexPath.row]
        
        let goalDetailsStoryboard: UIStoryboard = UIStoryboard(name: "GoalDetails", bundle: nil)
        let goalDetailsInitialViewController = goalDetailsStoryboard.instantiateInitialViewController()! as GoalDetailsViewController
        
        goalDetailsInitialViewController.savingsTarget = rowItem
        
        self.navigationController?.pushViewController(goalDetailsInitialViewController, animated: true)
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
    
    func showNavigationShowcase() {
        let activeGoalsTabBarButtonShowcase = MaterialShowcase()
        activeGoalsTabBarButtonShowcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 0)
        activeGoalsTabBarButtonShowcase.primaryText = "Active goals"
        activeGoalsTabBarButtonShowcase.secondaryText = "Your ongoing savings targets live here"
        activeGoalsTabBarButtonShowcase.targetHolderColor = .clear
        activeGoalsTabBarButtonShowcase.delegate = self
        
        let finishedGoalsTabBarButtonShowcase = MaterialShowcase()
        finishedGoalsTabBarButtonShowcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 1)
        finishedGoalsTabBarButtonShowcase.primaryText = "Finished goals"
        finishedGoalsTabBarButtonShowcase.secondaryText = "Once you've saved enough, your savings target will show up here"
        finishedGoalsTabBarButtonShowcase.targetHolderColor = .clear
        finishedGoalsTabBarButtonShowcase.delegate = self
        
        let calculatorTabBarButtonShowcase = MaterialShowcase()
        calculatorTabBarButtonShowcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 2)
        calculatorTabBarButtonShowcase.primaryText = "Calculator"
        calculatorTabBarButtonShowcase.secondaryText = "Calculate when you will reach your target if you put aside some money every day or how much you will need to save daily to reach you goals"
        calculatorTabBarButtonShowcase.targetHolderColor = .clear
        calculatorTabBarButtonShowcase.delegate = self
        
        let settingsBarButtonShowcase = MaterialShowcase()
        settingsBarButtonShowcase.setTargetView(barButtonItem: openSettingsBarButton)
        settingsBarButtonShowcase.primaryText = "Open settings"
        settingsBarButtonShowcase.secondaryText = "Click here to open the settings panel"
        settingsBarButtonShowcase.targetHolderColor = .clear
        settingsBarButtonShowcase.backgroundPromptColor = tintColor
        settingsBarButtonShowcase.delegate = self

        let helpBarButtonShowcase = MaterialShowcase()
        helpBarButtonShowcase.setTargetView(barButtonItem: helpBarButton)
        helpBarButtonShowcase.primaryText = "Help"
        helpBarButtonShowcase.secondaryText = "Stuck? Get help by clicking here"
        helpBarButtonShowcase.targetHolderColor = .clear
        helpBarButtonShowcase.backgroundPromptColor = tintColor
        helpBarButtonShowcase.delegate = self
        
        showcaseSequence
            .temp(activeGoalsTabBarButtonShowcase)
            .temp(finishedGoalsTabBarButtonShowcase)
            .temp(calculatorTabBarButtonShowcase)
            .temp(settingsBarButtonShowcase)
            .temp(helpBarButtonShowcase)
            .start()
        
        Onboarding.userDidCompleteNavigationShowcase = true
    }
    
    func showTableShowcase() {
    }

    @IBAction private func addTargetTapped(_ sender: RoundedButton) {
        let addGoalStoryboard: UIStoryboard = UIStoryboard(name: "AddGoal", bundle: nil)
        let addGoalInitialViewController = addGoalStoryboard.instantiateInitialViewController()!
        self.present(addGoalInitialViewController, animated: true)
    }
    
    @IBAction private func openSettingsTapped(_ sender: UIBarButtonItem) {
        let settingsController = SettingsController()
        self.presentAsLark(settingsController)
    }
    
    @IBAction private func helpTapped(_ sender: UIBarButtonItem) {
        showNavigationShowcase()
        showTableShowcase()
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

extension SavingsTargetsTableViewController: MaterialShowcaseDelegate {
  func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
    showcaseSequence.showCaseWillDismis()
  }
}
