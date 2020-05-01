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
        AuthenticationService.authenticate(completion: { authenticated in
            if authenticated {
                let homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()!
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
                keyWindow.rootViewController = homeViewController
                UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            } else {
                SPAlert.showErrorAlert(title: "Could not unlock", message: "Please try again")
            }
        })
    }
    
}
