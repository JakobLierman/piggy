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
        
        // Fill database
        if (db.realm.objects(Category.self).count == 0) {
            db.create(Category(id: nil, name: "Entertainment", iconPath: nil))
            db.create(Category(id: nil, name: "Household", iconPath: nil))
            db.create(Category(id: nil, name: "Gifts", iconPath: nil))
            db.create(Category(id: nil, name: "Clothing", iconPath: nil))
            db.create(Category(id: nil, name: "Transportation", iconPath: nil))
            db.create(Category(id: nil, name: "Travelling", iconPath: nil))
            db.create(Category(id: nil, name: "Hobbies", iconPath: nil))
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

