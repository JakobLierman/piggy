//
//  HelpViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 29/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit

class HelpViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = (sender as! UITableViewCell).textLabel?.text
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
