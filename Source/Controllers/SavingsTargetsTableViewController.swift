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
    
    lazy var activeGoalsTabBarButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 0)
        showcase.primaryText = "Active goals"
        showcase.secondaryText = "Your ongoing savings targets live here"
        showcase.targetHolderColor = .clear
        showcase.delegate = self
        return showcase
    }()
    lazy var finishedGoalsTabBarButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 1)
        showcase.primaryText = "Finished goals"
        showcase.secondaryText = "Once you've saved enough, your savings target will show up here"
        showcase.targetHolderColor = .clear
        showcase.delegate = self
        return showcase
    }()
    lazy var calculatorTabBarButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(tabBar: self.tabBarController!.tabBar, itemIndex: 2)
        showcase.primaryText = "Calculator"
        showcase.secondaryText = "Calculate when you will reach your target if you put aside some money every day or how much you will need to save daily to reach you goals"
        showcase.targetHolderColor = .clear
        showcase.delegate = self
        return showcase
    }()
    lazy var settingsBarButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(barButtonItem: openSettingsBarButton)
        showcase.primaryText = "Open settings"
        showcase.secondaryText = "Click here to open the settings panel"
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var helpBarButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(barButtonItem: helpBarButton)
        showcase.primaryText = "Help"
        showcase.secondaryText = "Stuck? Get help by clicking here"
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var addTargetButtonShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: addTargetButton)
        showcase.primaryText = "Start here!"
        showcase.secondaryText = "Add a new savings target by tapping this button"
        showcase.targetHolderColor = .clear
        showcase.delegate = self
        return showcase
    }()
    lazy var savingsTableShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: tableView)
        showcase.primaryText = "Your goals are all right here"
        showcase.secondaryText = "You can see all targets with name, catergory image, price and progress as cells in this table"
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
    }()
    lazy var deleteCellShowcase: MaterialShowcase = {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: tableView)
        showcase.primaryText = "Delete goals by swiping them left"
        showcase.secondaryText = nil
        showcase.targetHolderColor = .clear
        showcase.backgroundPromptColor = tintColor
        showcase.delegate = self
        return showcase
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
        
        if !Onboarding.usesOnboardingAndHelp {
            self.helpBarButton.hide()
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hidesBottomBarWhenPushed = true
        
        if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteGeneralOnboarding {
            onboardingBulletinManager.showBulletin(above: self)
        }
        
        if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteNavigationShowcase && (self.storyboard!.value(forKey: "name") as! String).starts(with: "Active") {
            showInitialShowcase()
        } else if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteTableShowcase {
            showTableShowcase()
        }
        
        if Onboarding.usesOnboardingAndHelp && !Onboarding.userDidCompleteDeleteShowcase && (self.storyboard!.value(forKey: "name") as! String).starts(with: "Finished") && tableView.numberOfRows(inSection: 0) != 0  {
            showDeleteShowcase()
        }
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
                tableView.setEmptyView(title: "You do not have any active goals", message: Onboarding.usesOnboardingAndHelp ? "Create one with the button above" : "")
            } else {
                tableView.setEmptyView(title: "You do not have any finished goals", message: Onboarding.usesOnboardingAndHelp ? "Start saving!" : "")
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
    
    func showInitialShowcase() {
        showcaseSequence
            .temp(activeGoalsTabBarButtonShowcase)
            .temp(finishedGoalsTabBarButtonShowcase)
            .temp(calculatorTabBarButtonShowcase)
            .temp(settingsBarButtonShowcase)
            .temp(helpBarButtonShowcase)
            .temp(addTargetButtonShowcase)
            .temp(savingsTableShowcase)
            .start()
            
        Onboarding.userDidCompleteNavigationShowcase = true
        Onboarding.userDidCompleteTableShowcase = true
    }
    
    func showTableShowcase() {
        showcaseSequence = MaterialShowcaseSequence()
        showcaseSequence
            .temp(addTargetButtonShowcase)
            .temp(savingsTableShowcase)
            .temp(deleteCellShowcase)
            .start()
        
        Onboarding.userDidCompleteTableShowcase = true
        Onboarding.userDidCompleteDeleteShowcase = true
    }
    
    func showDeleteShowcase() {
        showcaseSequence
            .temp(deleteCellShowcase)
            .start()
        
        Onboarding.userDidCompleteDeleteShowcase = true
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
