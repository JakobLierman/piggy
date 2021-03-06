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
    private let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SettingsBundle.setVersionAndBuildNumber()
        
        // First launch
        if defaults.object(forKey: "firstLaunch") == nil {
            defaults.set(true, forKey: "firstLaunch")
        } else {
            defaults.set(false, forKey: "firstLaunch")
        }
        
        if defaults.bool(forKey: "firstLaunch") {
            db.fill()
            Onboarding.reset()
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        AuthenticationService.setExpirationDate(Date())
    }

}

