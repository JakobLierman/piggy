//
//  AuthenticationService.swift
//  Piggy
//
//  Created by Jakob Lierman on 05/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import LocalAuthentication

class AuthenticationService {
    
    private static let defaults = UserDefaults.standard
    
    private enum Keys: String, CaseIterable {
        case loginStatus = "isLoggedIn"
        case expirationDate = "expirationDate"
        case useAuthentication = "useAuthentication"
    }
    
    static func isEnabled() -> Bool {
        return defaults.bool(forKey: Keys.useAuthentication.rawValue)
    }
    
    static func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock Piggy"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        completion(false)
                        // TODO: passwordNotSet
                    }
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            completion(false)
            // TODO: passwordNotSet
        }
    }
    
    static func setAuthentication(_ hasAuthentication: Bool) {
        defaults.set(hasAuthentication, forKey: Keys.useAuthentication.rawValue)
        defaults.set(true, forKey: Keys.loginStatus.rawValue)
    }
    
    static func setAuthenticated(_ isAuthenticated: Bool) {
        self.setExpirationDate(Date(timeIntervalSinceNow: 300))
        let useAuthentication = defaults.bool(forKey: Keys.useAuthentication.rawValue)
        defaults.set(useAuthentication ? isAuthenticated : useAuthentication, forKey: Keys.loginStatus.rawValue)
    }
    
    static func setExpirationDate(_ date: Date) {
        defaults.set(date, forKey: Keys.expirationDate.rawValue)
    }
    
    static func getExpirationDate() -> Date {
        return (defaults.object(forKey: Keys.expirationDate.rawValue) ?? Date()) as! Date
    }
    
    static func isAuthenticated() -> Bool {
        var isAuthenticated: Bool = true
        if (self.isEnabled()) {
            let isExpired = Date() > self.getExpirationDate()
            defaults.set(!isExpired, forKey: Keys.loginStatus.rawValue)
            isAuthenticated = defaults.bool(forKey: Keys.loginStatus.rawValue)
        }
        return isAuthenticated
    }
    
    static func resetSettings() {
        Keys.allCases.forEach {
            defaults.removeObject(forKey: $0.rawValue)
        }
    }
    
}
