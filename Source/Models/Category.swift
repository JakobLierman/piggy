//
//  Category.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/03/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Category: Object {
    
    // MARK: Properties
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var icon: String? = nil
    
    // MARK: Constructors
    convenience init(id: String?, name: String, icon: String?) {
        self.init()
        self.id = id ?? UUID().uuidString
        self.name = name
        self.icon = icon
    }
    
    // MARK: Functions
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
