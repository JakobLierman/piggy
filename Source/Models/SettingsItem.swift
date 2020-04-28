//
//  SettingsItem.swift
//  Piggy
//
//  Created by Jakob Lierman on 26/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class SettingsItem: Object {
    
    // MARK: Properties
    dynamic var id: String = UUID().uuidString
    dynamic var title: String = ""
    dynamic var subtitle: String? = nil
    dynamic var alternativeTitle: String? = nil
    dynamic var alternativeSubtitle: String? = nil
    dynamic var highlighted: Bool = true
    dynamic var functionName: String = "function"
    
    // MARK: Constructors
    convenience init(id: String? = nil, title: String, subtitle: String? = nil, alternativeTitle: String? = nil, alternativeSubtitle: String? = nil, highlighted: Bool = true, functionName: String) {
        self.init()
        self.id = id ?? UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.alternativeTitle = alternativeTitle
        self.alternativeSubtitle = alternativeSubtitle
        self.highlighted = highlighted
        self.functionName = functionName
    }
    
    // MARK: Functions
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["title"]
    }
    
    func toggleHighlighted() {
        let db = RealmService.shared
        db.update(self, with: ["highlighted": !self.highlighted])
    }
    
}

