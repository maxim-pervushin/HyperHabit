//
// Created by Maxim Pervushin on 27/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseService: NSObject {

    static let requestedCacheCleanNotification = "ParseServiceRequestedCacheCleanNotification"

    private var _changesObserver: ChangesObserver?

    init(applicationId: String, clientKey: String) {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }

    func changed() {
        _changesObserver?.observableChanged(self)
    }

//    // TODO: Find better way to notificate 'Cache' objects about need in reset.
//    func requestCacheClean() {
//        NSNotificationCenter.defaultCenter().postNotificationName(ParseService.requestedCacheCleanNotification, object: self)
//    }
}

extension ParseService: ServiceAuthentication {

    func signUpWithUsername(username: String, password: String, block: (Bool, NSError?) -> Void) {
        let user = PFUser()
        user.username = username
        user.email = username
        user.password = password
        user.signUpInBackgroundWithBlock() {
            success, error in
            block(success, error)
        }
    }

    func logInWithUsername(username: String, password: String, block: (Bool, NSError?) -> Void) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            user, error in
            block(nil != user, error)
        }
    }

    func logOut(block: (Bool, NSError?) -> Void) {
        if !available {
            return
        }

        PFUser.logOutInBackgroundWithBlock() {
            error in
            block(error == nil, error)
        }
    }

    func resetPasswordWithUsername(username: String, block: (Bool, NSError?) -> Void) {
        PFUser.requestPasswordResetForEmailInBackground(username) {
            success, error in
            block(success, error)
        }
    }
}

extension ParseService: Service {

    var changesObserver: ChangesObserver? {
        get {
            return _changesObserver
        }
        set {
            _changesObserver = newValue
        }
    }

    var available: Bool {
        return PFUser.currentUser() != nil
    }

    var username: String {
        if let username = PFUser.currentUser()?.username {
            return username
        }
        return ""
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
