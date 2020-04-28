//
//  AppDelegate.swift
//  Piggy
//
//  Created by Jakob Lierman on 24/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    private let db = RealmService.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // If login is expired
        if (!AuthenticationService.isAuthenticated()) {
            // TODO - Do authentication
            print("Not authenticated")
        }
        
        // Load settings
        // Settings dummy data
        if (db.realm.objects(SettingsItem.self).count == 0) {
            db.create(SettingsItem(id: nil, title: "Lock", subtitle: "Enabled", alternativeSubtitle: "Disabled", functionName: "lock"))
            db.create(SettingsItem(title: "Help", functionName: "help"))
            db.create(SettingsItem(id: nil, title: "Currency", subtitle: "EUR", functionName: "currency"))
            db.create(SettingsItem(title: "Reset", highlighted: false, functionName: "reset"))
            db.create(SettingsItem(title: "About", functionName: "about"))
        }
        
        // Fill database
        if (db.realm.objects(Category.self).count == 0) {
            db.create(Category(id: nil, name: "Entertainment", icon: "dice"))
            db.create(Category(id: nil, name: "Household", icon: "fridge"))
            db.create(Category(id: nil, name: "Gifts", icon: "balloon"))
            db.create(Category(id: nil, name: "Clothing", icon: "hanger"))
            db.create(Category(id: nil, name: "Transportation", icon: "car"))
            db.create(Category(id: nil, name: "Travelling", icon: "luggage"))
            db.create(Category(id: nil, name: "Hobbies", icon: "gamer"))
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // TODO expire date
    
    // TODO log out on exit

}

