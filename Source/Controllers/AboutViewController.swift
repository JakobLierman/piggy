//
//  AboutViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 28/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SwiftConfettiView

class AboutViewController: UIViewController {
    
    let easterEggCounter = 0
    
    @IBOutlet var confettiView: SwiftConfettiView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "Version 0.0.1 alpha"
        
        confettiView.type = .confetti
        
        let seconds = 15.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.confettiView.startConfetti()
        }
    }

    @IBAction func didTapGithub(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/JakobLierman/piggy") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapWebsite(_ sender: UIButton) {
        if let url = URL(string: "https://jakoblierman.be") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
