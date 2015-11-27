//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class PlistStorage: DataProvider {

    // MARK: PlistStorage

    private var _habitsById = [String: Habit]()

    private var _reportsById = [String: Report]()

    private let contentDirectory: NSString

    private var habitsFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/habits.plist")
    }

    private var reportsFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/reports.plist")
    }

    private func loadHabitsById() {
        guard let packedHabits = NSArray(contentsOfFile: habitsFilePath) else {
            return
        }

        var habitsById = [String: Habit]()
        for packedHabit in packedHabits {
            if let dictionary = packedHabit as? [String:AnyObject],
            habit = Habit(packed: dictionary) {
                habitsById[habit.id] = habit
            }
        }
        _habitsById = habitsById
    }

    private func saveHabitsById() -> Bool {
        let packedHabits = NSMutableArray()
        for habit in _habitsById.values {
            packedHabits.addObject(habit.packed)
        }
        print("\(habitsFilePath)")
        return packedHabits.writeToFile(habitsFilePath, atomically: true)
    }

    private func loadReportsById() {
        guard let packedReports = NSArray(contentsOfFile: reportsFilePath) else {
            return
        }

        var reportsById = [String: Report]()
        for packedReport in packedReports {
            if let dictionary = packedReport as? [String:AnyObject],
            report = Report(packed: dictionary) {
                reportsById[report.id] = report
            }
        }
        _reportsById = reportsById
    }

    private func saveReportsById() -> Bool {
        let packedReports = NSMutableArray()
        for report in _reportsById.values {
            packedReports.addObject(report.packed)
        }
        print("\(reportsFilePath)")
        return packedReports.writeToFile(reportsFilePath, atomically: true)
    }

    init(contentDirectory: String) {
        self.contentDirectory = contentDirectory
        loadHabitsById()
        loadReportsById()
    }

    // MARK: DataProvider

    var habits: [Habit] {
        return Array(_habitsById.values)
    }

    func saveHabit(habit: Habit) -> Bool {
        _habitsById[habit.id] = habit
        return saveHabitsById()
    }

    func deleteHabit(habit: Habit) -> Bool {
        _habitsById[habit.id] = nil
        return saveHabitsById()
    }

    var reports: [Report] {
        return Array(_reportsById.values)
    }

    func reportsForDate(date: NSDate) -> [Report] {
        return Array(_reportsById.values.filter {
            return $0.date.dateComponent == date.dateComponent
        })
    }

    func saveReport(report: Report) -> Bool {
        _reportsById[report.id] = report
        return saveReportsById()
    }

    func deleteReport(report: Report) -> Bool {
        _reportsById[report.id] = nil
        return saveReportsById()
    }

    func reportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) -> [Report] {
        return []
    }
}

extension Habit {

    convenience init?(packed: [String:AnyObject]) {
        if let
        id = packed["id"] as? String,
        name = packed["name"] as? String,
        repeatsTotal = packed["repeatsTotal"] as? Int,
        active = packed["active"] as? Bool {
            self.init(id: id, name: name, repeatsTotal: repeatsTotal, active: active)
        } else {
            return nil
        }
    }

    var packed: [String:AnyObject] {
        return [
                "id": id,
                "name": name,
                "repeatsTotal": repeatsTotal,
                "active": active
        ]
    }
}

extension Report {

    convenience init?(packed: [String:AnyObject]) {
        if let
        id = packed["id"] as? String,
        habitName = packed["habitName"] as? String,
        habitRepeatsTotal = packed["habitRepeatsTotal"] as? Int,
        repeatsDone = packed["repeatsDone"] as? Int,
        dateComponent = packed["date_dateComponent"] as? String,
        date = NSDate.dateWithDateComponent(dateComponent) {
            self.init(id: id, habitName: habitName, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: repeatsDone, date: date)
        } else {
            return nil
        }
    }

    var packed: [String:AnyObject] {
        return [
                "id": id,
                "habitName": habitName,
                "habitRepeatsTotal": habitRepeatsTotal,
                "repeatsDone": repeatsDone,
                "date_dateComponent": date.dateComponent,
        ]
    }
}