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
    @IBOutlet weak var generateTestDataContainer: UIView?

    @IBAction func toggleAuthenticationAction(sender: AnyObject) {
        App.authenticated ? logOut() : logIn()
    }

    @IBAction func generateTestDataAction(sender: AnyObject) {
        generateTestData()
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

    override func viewDidLoad() {
        super.viewDidLoad()
#if ( arch(i386) || arch(x86_64)) && os(iOS)
        generateTestDataContainer?.hidden = false
#else
        generateTestDataContainer?.hidden = true
#endif
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

extension SettingsViewController {

    func generateTestData() {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let groupIdentifier = "group.hyperhabit"
            if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)?.path as? NSString {
                let files = ["habits.plist", "habitsToSave.plist", "reports.plist", "reportsToSave.plist"]
                for file in files {
                    if let path = NSBundle.mainBundle().pathForResource(file, ofType: nil) {
                        let toPath = contentDirectory.stringByAppendingPathComponent("/\(file)")
                        try? NSFileManager.defaultManager().copyItemAtPath(path, toPath: toPath)
                    }
                }
            }

//            // Habits
//            print("Generating habits...")
//            let meditate = Habit(name: "Meditate", definition: "", repeatsTotal: 1, active: true)
//            let exercise = Habit(name: "Exercise", definition: "Make 100 push ups", repeatsTotal: 1, active: true)
//            let eat = Habit(name: "Eat more vegetables", definition: "", repeatsTotal: 1, active: true)
//            let drink = Habit(name: "Drink more water", definition: "At least 2 litres", repeatsTotal: 1, active: true)
//            let read = Habit(name: "Read", definition: "", repeatsTotal: 1, active: true)
//            let habits = [meditate, exercise, eat, drink, read]
//            for habit in habits {
//                App.dataProvider.saveHabit(habit)
//            }
//            print("Done.")
//
//            // Reports
//            print("Generating reports...")
//            let today = NSDate()
//            for index in -31 ... 0 {
//                let date = today.dateByAddingDays(index)
//                for habit in habits {
//                    let report = Report(habit: habit, repeatsDone: arc4random_uniform(10) > 2 ? habit.repeatsTotal : 0, date: date)
//                    App.dataProvider.saveReport(report)
//                }
//                print("index: \(index + 31 ) of 31")
//            }
//            print("Done.")
        }
    }
}