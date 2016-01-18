//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class SettingsViewController: ThemedTableViewController {

    // MARK: SettingsViewController @IB

    @IBOutlet weak var authenticationStatusLabel: UILabel!
    @IBOutlet weak var toggleAuthenticationButton: UIButton!

    @IBAction func toggleAuthenticationButtonAction(sender: AnyObject) {
        if App.authenticated {
            App.logOut(self)
        } else {
            App.logIn(self)
        }
        updateUI()
    }

    // MARK: SettingsViewController

    private func updateUI() {
        if App.authenticated {
            authenticationStatusLabel.text = "Authenticated"
            toggleAuthenticationButton.setTitle("Log Out", forState: .Normal)
        } else {
            authenticationStatusLabel.text = "Not Authenticated"
            toggleAuthenticationButton.setTitle("Authenticate", forState: .Normal)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}
