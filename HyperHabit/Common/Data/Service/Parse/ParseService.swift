//
// Created by Maxim Pervushin on 27/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

// TODO: Load data after successfull authentication

class ParseService: NSObject {

    init(applicationId: String, clientKey: String) {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }
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
        guard let user = PFUser.currentUser() else {
            return []
        }
        let query = PFQuery(className: "Habit")
        query.whereKey("user", equalTo: user)
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
        guard let user = PFUser.currentUser() else {
            return
        }
        var objects = [PFObject]()
        for habit in habits {
            objects.append(habit.getParseObjectForUser(user))
        }

        try PFObject.saveAll(objects)
    }

    func getReports() throws -> [Report] {
        guard let user = PFUser.currentUser() else {
            return []
        }
        let query = PFQuery(className: "Report")
        query.whereKey("user", equalTo: user)
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
        guard let user = PFUser.currentUser() else {
            return
        }
        var objects = [PFObject]()
        for report in reports {
            objects.append(report.getParseObjectForUser(user))
        }

        try PFObject.saveAll(objects)
    }

    func deleteReports(reports: [Report]) throws {
        guard let user = PFUser.currentUser() else {
            return
        }
        var objects = [PFObject]()
        for report in reports {
            objects.append(report.getParseObjectForUser(user))
        }

        try PFObject.deleteAll(objects)
    }
}
