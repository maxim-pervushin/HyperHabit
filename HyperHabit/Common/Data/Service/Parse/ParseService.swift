//
// Created by Maxim Pervushin on 27/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

class ParseService {

    init(applicationId: String, clientKey: String) {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }
}

extension ParseService: Service {

    var available: Bool {
        return true
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