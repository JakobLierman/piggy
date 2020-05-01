//
//  LoginViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 05/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import LocalAuthentication
import SPAlert

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attemptUnlock(nil)
    }
    
    @IBAction func attemptUnlock(_ sender: UIControl?) {
    }
    
}
