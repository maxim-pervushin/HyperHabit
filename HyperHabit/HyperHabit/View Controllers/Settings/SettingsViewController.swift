//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class SettingsViewController: ThemedViewController {

    // MARK: SettingsViewController @IB

    @IBOutlet weak var themeNameLabel: UILabel?
    @IBOutlet weak var authenticationStatusLabel: UILabel?
    @IBOutlet weak var toggleAuthenticationLabel: UILabel?

    @IBAction func toggleAuthenticationAction(sender: AnyObject) {
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
            authenticationStatusLabel?.text = App.username
            toggleAuthenticationLabel?.text = "Log Out"
        } else {
            authenticationStatusLabel?.text = "Not Authenticated"
            toggleAuthenticationLabel?.text = "Log In"
        }

        themeNameLabel?.text = App.themeManager.theme.name
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}
