//
//  Bundle.swift
//  Piggy
//
//  Created by Jakob Lierman on 09/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
