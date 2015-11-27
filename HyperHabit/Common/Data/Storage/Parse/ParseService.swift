//
// Created by Maxim Pervushin on 27/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

class ParseService {

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

extension Habit {

    convenience init?(parseObject: PFObject) {
        if let
        id = parseObject["identifier"] as? String,
        name = parseObject["name"] as? String,
        repeatsTotal = parseObject["repeatsTotal"] as? Int,
        active = parseObject["active"] as? Bool {
            self.init(id: id, name: name, repeatsTotal: repeatsTotal, active: active)
        } else {
            return nil
        }
    }

    var parseObject: PFObject {
        let idQuery = PFQuery(className: "Habit")
        idQuery.whereKey("identifier", equalTo: id)
        let nameQuery = PFQuery(className: "Habit")
        nameQuery.whereKey("name", equalTo: name)
        let query = PFQuery.orQueryWithSubqueries([idQuery, nameQuery])
        if let existingObject = try? query.getFirstObject() {
            existingObject["name"] = name
            existingObject["repeatsTotal"] = repeatsTotal
            existingObject["active"] = active
            return existingObject
        }
        let newObject = PFObject(className: "Habit")
        newObject["identifier"] = id
        newObject["name"] = name
        newObject["repeatsTotal"] = repeatsTotal
        newObject["active"] = active
        return newObject
    }
}

extension Report {

    convenience init?(parseObject: PFObject) {
        if let
        id = parseObject["identifier"] as? String,
        habitName = parseObject["habitName"] as? String,
        habitRepeatsTotal = parseObject["habitRepeatsTotal"] as? Int,
        repeatsDone = parseObject["repeatsDone"] as? Int,
        dateComponent = parseObject["date_dateComponent"] as? String,
        date = NSDate.dateWithDateComponent(dateComponent) {
            self.init(id: id, habitName: habitName, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: repeatsDone, date: date)
        } else {
            return nil
        }
    }

    var parseObject: PFObject {
        let query = PFQuery(className: "Report")
        query.whereKey("identifier", equalTo: id)
        if let existingObject = try? query.getFirstObject() {
            existingObject["habitName"] = habitName
            existingObject["habitRepeatsTotal"] = habitRepeatsTotal
            existingObject["repeatsDone"] = repeatsDone
            existingObject["date_dateComponent"] = date.dateComponent
            return existingObject
        }
        let newObject = PFObject(className: "Report")
        newObject["identifier"] = id
        newObject["habitName"] = habitName
        newObject["habitRepeatsTotal"] = habitRepeatsTotal
        newObject["repeatsDone"] = repeatsDone
        newObject["date_dateComponent"] = date.dateComponent
        return newObject
    }
}