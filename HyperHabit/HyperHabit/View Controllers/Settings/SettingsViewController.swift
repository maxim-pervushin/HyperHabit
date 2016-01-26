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
        App.authenticated ? logOut() : logIn()
    }

    // MARK: SettingsViewController

    private let dataSource = SettingsDataSource()

    private func logOut() {
        let alert = UIAlertController(title: "Log Out", message: "Do you want to delete local data?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {
            _ in
            App.logOut() {
                success, error in
                self.updateUI()
            }
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: {
            _ in
            App.logOut() {
                success, error in
                self.dataSource.clearCache()
                self.updateUI()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    private func logIn() {
        performSegueWithIdentifier("ShowLogIn", sender: self)
    }

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let logInViewController = segue.destinationViewController as? LogInViewController {
            logInViewController.completionHandler = {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.updateUI()
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }

}
