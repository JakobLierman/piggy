//
//  SettingsBundle.swift
//  Piggy
//
//  Created by Jakob Lierman on 09/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

class SettingsBundle {
    struct SettingsBundleKeys {
        static let Onboarding = "enabled_onboarding"
        static let AppVersionKey = "version_preference"
        static let BuildVersionKey = "build_preference"
    }
    
    class func checkAndExecuteSettings() {
        // Check settings and make changes
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.releaseVersionNumber!
        UserDefaults.standard.set(version, forKey: "version_preference")
        let build: String = Bundle.main.buildVersionNumber!
        UserDefaults.standard.set(build, forKey: "build_preference")
    }
}
