//
// Created by Maxim Pervushin on 27/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Parse
import ParseUI

class ParseService {


    init(applicationId: String, clientKey: String) {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }

    func logOut(viewController: UIViewController) {
        if !available {
            return
        }

        ParseService.authentication.logOut(viewController)
    }

    func authenticate(viewController: UIViewController) {
        if available {
            return
        }

        ParseService.authentication.authenticate(viewController)
    }

    private static let authentication = ParseAuthentication()
}

extension ParseService: Service {

    var available: Bool {
        return PFUser.currentUser() != nil
    }

    func getHabits() throws -> [Habit] {
        let query = PFQuery(className: "Habit")
        var habits = [Habit]()
        if let objects = try? query.findObjects() {
            for object in objects {
                if let habit = Habit(parseObject: object) {
                    habits.append(habit)
                }
            }
        }
        return habits
    }

    func saveHabits(habits: [Habit]) throws {
        var objects = [PFObject]()
        for habit in habits {
            objects.append(habit.parseObject)
        }

        try PFObject.saveAll(objects)
    }

    func getReports() throws -> [Report] {
        let query = PFQuery(className: "Report")
        var reports = [Report]()
        if let objects = try? query.findObjects() {
            for object in objects {
                if let habit = Report(parseObject: object) {
                    reports.append(habit)
                }
            }
        }
        return reports
    }

    func saveReports(reports: [Report]) throws {
        var objects = [PFObject]()
        for report in reports {
            objects.append(report.parseObject)
        }

        try PFObject.saveAll(objects)
    }

    func deleteReports(reports: [Report]) throws {
        var objects = [PFObject]()
        for report in reports {
            objects.append(report.parseObject)
        }

        try PFObject.deleteAll(objects)
    }
}

extension Parse {

//    private static var onceToken: dispatch_once_t = 0
//    private static let authentication = ParseAuthentication()
//
//    static var authenticated: Bool {
//        checkEnabled()
//        return PFUser.currentUser() != nil
//    }
//
//    static func checkEnabled() {
//        dispatch_once(&onceToken) {
//            Parse.enableLocalDatastore()
//            Parse.setApplicationId(ParseConfiguration.applicationId, clientKey: ParseConfiguration.clientKey)
//            PFTwitterUtils.initializeWithConsumerKey("ej9vt7QydS4mJI07U6QZlmO4T", consumerSecret: "WhPa7Bf2XdModQj6uHzq5PlQnDdF5R65EZPJzJOBs5NgpFVvk3")
////            PFFacebookUtils.initializeFacebook()
//        }
//    }

//    static func logOut(viewController: UIViewController) {
//        if !authenticated {
//            return
//        }
//
//        Parse.authentication.logOut(viewController)
//    }
//
//    static func authenticate(viewController: UIViewController) {
//        if authenticated {
//            return
//        }
//
//        checkEnabled()
//        Parse.authentication.authenticate(viewController)
//    }
}

class ParseAuthentication: NSObject, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    static let statusUpdatedNotification = "ParseAuthenticationStatusUpdatedNotification"

    private func statusUpdated() {
        NSNotificationCenter.defaultCenter().postNotificationName(ParseAuthentication.statusUpdatedNotification, object: self)
    }

    public func logOut(viewController: UIViewController) {
        PFUser.logOut()
        statusUpdated()

        // TODO: Add Cancel button
        // Ask user if we should to delete all cached data
        let alertController = UIAlertController(title: "Log Out", message: "Do you want to delete local data?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Keep", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
            (action) in
//            App.dataManager.clear()
        }))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }

    public func authenticate(viewController: UIViewController) {
        let logInController = PFLogInViewController()
//        logInController.fields = (.UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .DismissButton | .Facebook | .Twitter)
        logInController.delegate = self
//        if let view = logInController.view as? PFLogInView {
//            view.backgroundColor = App.themeManager.currentTheme.backgroundColor
//            view.usernameField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.usernameField?.separatorStyle = .None
//            view.passwordField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.passwordField?.separatorStyle = .None
//        }
//        if let logoImageView = logInController.logInView?.logo as? UIImageView {
//            logoImageView.image = UIImage(named: "Background")
//        }
//        if let view = logInController.signUpController?.view as? PFSignUpView {
//            view.backgroundColor = App.themeManager.currentTheme.backgroundColor
//            view.usernameField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.usernameField?.separatorStyle = .None
//            view.passwordField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.passwordField?.separatorStyle = .None
//            view.emailField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.emailField?.separatorStyle = .None
//            view.additionalField?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
//            view.additionalField?.separatorStyle = .None
//        }
//        if let logoImageView = logInController.signUpController?.signUpView?.logo as? UIImageView {
//            logoImageView.image = UIImage(named: "Background")
//        }
        logInController.signUpController?.emailAsUsername = true
        logInController.signUpController?.delegate = self
        viewController.presentViewController(logInController, animated: true, completion: nil)
    }

    // MARK: - PFLogInViewControllerDelegate,

    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
        statusUpdated()
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
        statusUpdated()
    }

    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        var localizedDescription = "Unknown error"
        if let error = error {
            localizedDescription = error.localizedDescription
        }
        print(localizedDescription)
        statusUpdated()
    }

    // MARK: - PFSignUpViewControllerDelegate

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }

    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        var localizedDescription = "Unknown error"
        if let error = error {
            localizedDescription = error.localizedDescription
        }
        print(localizedDescription)
    }

    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }
}