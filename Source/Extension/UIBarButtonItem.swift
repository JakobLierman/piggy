//
//  UIBarButtonItem.swift
//  Piggy
//
//  Created by Jakob Lierman on 09/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    func hide() {
        self.tintColor = UIColor.clear
        self.isEnabled = false
    }
    
}
