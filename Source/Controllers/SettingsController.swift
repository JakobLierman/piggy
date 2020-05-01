//
//  SettingsController.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SPLarkController
import RealmSwift

class SettingsController: SPLarkSettingsController {
    
    var settingsItems: [SettingsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsItems.append(SettingsItem(title: "Lock", subtitle: "Enabled", alternativeSubtitle: "Disabled", highlighted: AuthenticationService.isEnabled(), functionName: "lock"))
        settingsItems.append(SettingsItem(title: "Currency", subtitle: User.currentUser().currency, functionName: "currency"))
        settingsItems.append(SettingsItem(title: "Name", subtitle: User.currentUser().name, functionName: "name"))
        settingsItems.append(SettingsItem(title: "About", functionName: "about"))
        settingsItems.append(SettingsItem(title: "Help", functionName: "help"))
        settingsItems.append(SettingsItem(title: "Reset", highlighted: false, functionName: "reset"))
    }
    
    override func settingsCount() -> Int {
        return settingsItems.count
    }
    
    override func settingTitle(index: Int, highlighted: Bool) -> String {
        let title: String = settingsItems[index].title
        let alternativeTitle: String = settingsItems[index].alternativeTitle ?? title
        return highlighted ? title : alternativeTitle
    }
    
    override func settingSubtitle(index: Int, highlighted: Bool) -> String? {
        if settingsItems[index].title == "Currency" {
            return User.currentUser().currency
        }
        let subtitle: String? = settingsItems[index].subtitle
        let alternativeSubtitle: String? = settingsItems[index].alternativeSubtitle ?? subtitle
        return highlighted ? subtitle : alternativeSubtitle
    }
    
    override func settingHighlighted(index: Int) -> Bool {
        return settingsItems[index].highlighted
    }
    
    override func settingColorHighlighted(index: Int) -> UIColor {
        return UIColor(named: "Primary")!
    }
    
    override func settingDidSelect(index: Int, completion: @escaping () -> ()) {
        switch settingsItems[index].functionName {
            case "lock":
                self.toggleLock(settingsItems[index], completion: { () in
                    self.settingsItems[index].highlighted = AuthenticationService.isEnabled()
                    self.reload(index: index)
                })
                break
            case "currency":
                self.showCurrencySwitcher(User.currentUser().currency, completion: { currency in
                    User.currentUser().updateCurrency(currency)
                    self.reload(index: index)
                    SPLarkController.updatePresentingController(modal: self)
                })
                break
            case "name":
                // TODO: Change name functionality
                break
            case "help":
                self.showViewController(storyboard: "Help")
                break
            case "about":
                self.showViewController(storyboard: "About")
                break
            case "reset":
                self.showResetConfirm() // TODO: Completion
                break
            default:
                fatalError()
        }
    }
    
    private func toggleLock(_ item: SettingsItem, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Primary")
        
        if AuthenticationService.isEnabled() {
            alert.message = nil
            alert.addAction(UIAlertAction(title: "Disable lock", style: .default, handler: { _ in
                AuthenticationService.setAuthentication(false)
                completion()
            }))
        } else {
            alert.message = "Securing only works when you phone's password is set."
            alert.addAction(UIAlertAction(title: "Enable lock", style: .default, handler: { _ in
                AuthenticationService.setAuthentication(true)
                completion()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showCurrencySwitcher(_ currentValue: String, completion: @escaping (_ value: String) -> Void) {
        let alert = UIAlertController(title: "Currency", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Primary")
        
        let currencies = ["EUR": "€", "USD": "$", "GBP": "£"]
        
        for currency in currencies {
            let action = UIAlertAction(title: "\(currency.key) \(currency.value)", style: .default, handler: { _ in
                completion(currency.key)
            });
            action.setValue(currentValue == currency.key, forKey: "checked")
            alert.addAction(action);
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showViewController(storyboard: String) {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateInitialViewController()!
        
        self.present(viewController, animated: true)
    }
    
    private func showResetConfirm() {
        let alert = UIAlertController(title: "Reset data", message: "This action can't be undone.", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Primary")
        
        alert.addAction(UIAlertAction(title: "Reset my data", style: .destructive, handler: { _ in
            // TODO: Reset data functionality
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}

struct SettingsItem {
    var title: String
    var subtitle: String?
    var alternativeTitle: String? = nil
    var alternativeSubtitle: String? = nil
    var highlighted: Bool = true
    var functionName: String?
}
