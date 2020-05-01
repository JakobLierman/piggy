//
//  SPAlert.swift
//  Piggy
//
//  Created by Jakob Lierman on 01/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import SPAlert

extension SPAlert {
    
    public static func showErrorAlert(title: String, message: String) {
        let alert = SPAlertView(title: title, message: message, preset: .error)
        alert.duration = 3
        alert.dismissByTap = true
        alert.haptic = .error
        alert.present()
    }
    
}
