//
//  HelpViewController.swift
//  Piggy
//
//  Created by Jakob Lierman on 29/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import SPAlert

class HelpViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = (sender as! UITableViewCell).textLabel?.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [2, 3] { // Reset onboarding
            Onboarding.restart()
            SPAlert.present(title: "Showing help again", preset: .done)
            self.dismiss(animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath == [2, 4] { // Contact support
            if let url = URL(string: "https://github.com/JakobLierman/piggy/issues") {
                UIApplication.shared.open(url, options: [:])
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
