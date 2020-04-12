//
//  AuthenticationService.swift
//  Piggy
//
//  Created by Jakob Lierman on 05/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation


class AuthenticationService {
    
    private static let userDefault = UserDefaults.standard
    
    private enum Keys: String {
        case loginStatus = "isLoggedIn"
        case expirationDate = "expirationDate"
        case useAuthentication = "useAuthentication"
    }
    
    static func toggleAuthentication(_ hasAuthentication: Bool) {
        userDefault.set(hasAuthentication, forKey: Keys.useAuthentication.rawValue)
        userDefault.set(true, forKey: Keys.loginStatus.rawValue)
    }
    
    static func setAuthenticated(_ isAuthenticated: Bool) {
        let expirationDate = Date(timeIntervalSinceNow: 300)
        let useAuthentication = userDefault.bool(forKey: Keys.useAuthentication.rawValue)
        userDefault.set(useAuthentication ? useAuthentication : isAuthenticated, forKey: Keys.loginStatus.rawValue)
        userDefault.set(expirationDate, forKey: Keys.expirationDate.rawValue)
    }
    
    static func isAuthenticated() -> Bool {
        let useAuthentication = userDefault.bool(forKey: Keys.useAuthentication.rawValue)
        if (useAuthentication) {
            let isExpired = Date() > userDefault.object(forKey: Keys.expirationDate.rawValue) as! Date
                userDefault.set(!isExpired, forKey: Keys.loginStatus.rawValue)
        }
        return userDefault.bool(forKey: Keys.loginStatus.rawValue)
    }
    
}
