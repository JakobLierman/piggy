//
//  Onboarding.swift
//  Piggy
//
//  Created by Jakob Lierman on 06/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import BLTNBoard

class Onboarding {
    
    static private let defaults = UserDefaults.standard
    static private let tintColor = UIColor(named: "Primary")!
    
    static var userDidCompleteGeneralOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedGeneralOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedGeneralOnboarding")
        }
    }
    static var userDidCompleteNavigationShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedNavigationShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedNavigationShowcase")
        }
    }
    static var userDidCompleteTableShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedTableShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedTableShowcase")
        }
    }
    static var userDidCompleteCalculatorShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedCalculatorShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedCalculatorShowcase")
        }
    }
    static var userDidCompleteNewShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedNewShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedNewShowcase")
        }
    }
    static var userDidCompleteDeleteShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedDeleteShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedDeleteShowcase")
        }
    }
    static var userDidCompleteSettingsShowcase: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "completedSettingsShowcase")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completedSettingsShowcase")
        }
    }
    
    static func restart() {
        
        userDidCompleteGeneralOnboarding = false
        userDidCompleteNavigationShowcase = false
        userDidCompleteTableShowcase = false
        userDidCompleteCalculatorShowcase = false
        userDidCompleteNewShowcase = false
        userDidCompleteDeleteShowcase = false
        userDidCompleteSettingsShowcase = false
        
    }
    
    static func makeWelcomePage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Welcome to\nPiggy")
        
        page.image = UIImage(named: "Rounded Background AppIcon")?
            .resizeImage(128, opaque: false)
        
        page.descriptionText = "Organize you savings targets and reach you goals faster."
        
        page.actionButtonTitle = "Continue"
        page.appearance.actionButtonColor = tintColor
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }
        
        page.isDismissable = false
        
        page.next = makeNamePage()
        
        return page
        
    }

    static func makeNamePage() -> TextFieldBLTNPageItem {
        
        let page = TextFieldBLTNPageItem(title: "How should we call you?")
    
        page.actionButtonTitle = "Continue"
        page.appearance.actionButtonColor = self.tintColor
        page.textInputHandler = { item, text in
            User.currentUser().updateName(text ?? "Saver")
            item.manager?.push(item: makeCurrencyPage(userName: User.currentUser().name))
        }
        
        page.alternativeButtonTitle = "Skip"
        page.appearance.alternativeButtonTitleColor = tintColor
        page.alternativeHandler = { item in
            item.manager?.push(item: makeCurrencyPage(userName: User.currentUser().name))
        }
        
        page.isDismissable = false
        
        return page
        
    }
    
    static func makeCurrencyPage(userName: String) -> CurrencySelectorBLTNPageItem {
        
        let page = CurrencySelectorBLTNPageItem(title: "Choose your currency")
        
        page.descriptionText = "What currency do you use, \(userName)?"
        
        page.actionButtonTitle = "Continue"
        page.appearance.actionButtonColor = tintColor
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }
        
        page.isDismissable = false
        
        page.next = makeLockPage()
        
        return page
        
    }
    
    static func makeLockPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Lock")

        page.image = UIImage.init(systemName: "lock.circle.fill")?
            .resizeImage(128, opaque: false)
            .withTintColor(tintColor)
        
        page.descriptionText = "Require authentication on application launch."
        
        page.actionButtonTitle = "Enable lock"
        page.appearance.actionButtonColor = tintColor
        page.actionHandler = { item in
            AuthenticationService.setAuthentication(true)
            item.manager?.push(item: makeCompletionPage(userName: User.currentUser().name))
        }
        
        page.alternativeButtonTitle = "No thanks"
        page.appearance.alternativeButtonTitleColor = tintColor
        page.alternativeHandler = { item in
            item.manager?.push(item: makeCompletionPage(userName: User.currentUser().name))
        }
        
        page.isDismissable = false
        
        return page
        
    }
    
    static func makeCompletionPage(userName: String) -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Setup Completed")
        
        page.image = UIImage.init(systemName: "checkmark.circle.fill")?
            .resizeImage(128, opaque: false)
            .withTintColor(tintColor)
        
        page.descriptionText = "Congratulations, \(userName)! Piggy is all set up."
        
        page.actionButtonTitle = "Start saving"
        page.appearance.actionButtonColor = tintColor
        page.actionHandler = { item in
            userDidCompleteGeneralOnboarding = true
            item.manager?.dismissBulletin()
        }
        
        page.isDismissable = false
        
        return page
        
    }
    
}
