//
//  User.swift
//  Piggy
//
//  Created by Jakob Lierman on 27/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

struct Defaults {
    private static let userDefault = UserDefaults.standard
    
    private enum Keys: String {
        case user
        case name
        case currency
    }
    
    /**
     - Description - It's using for the passing and fetching
                  user values from the UserDefaults.
     */
    struct UserDetails {
        let name: String
        let currency: String
        
        init(_ json: [String: Any]) {
            self.name = json[Keys.name.rawValue] as? String ?? ""
            self.currency = json[Keys.currency.rawValue] as? String ?? ""
        }
    }
    
    /**
     - Description - Saving user details
     - Inputs - name `String` & address `String`
     */
    static func saveUserDetails(name: String, currency: String) {
        userDefault.set([Keys.name.rawValue: name, Keys.currency.rawValue: currency],
                        forKey: Keys.user.rawValue)
    }
    
    /**
     - Description - Fetching Values via Model `UserDetails` you can use it based on your uses.
     - Output - `UserDetails` model
     */
    static func getUserDetails() -> UserDetails {
        return UserDetails((userDefault.value(forKey: Keys.user.rawValue) as? [String: Any]) ?? [:])
    }
    
    /**
     - Description - Clearing user details for the key `user`
     */
    static func clearUserData() {
        userDefault.removeObject(forKey: Keys.user.rawValue)
    }
}
