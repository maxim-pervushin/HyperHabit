//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

// TODO: This class far from perfect. Need to rewrite it ever.
// TODO: Should be able to fetch data from Parse without re-initialization.

class ParseStorage {

    private var _timer: NSTimer!

    private var _habitsById = [String: Habit]() {
        didSet {
            changed()
        }
    }

    private var _habitsByIdToSave = [String: Habit]() {
        didSet {
            _saveHabitsAfter = 2
        }
    }

    private var _saveHabitsAfter = Int.max

    private var _reportsById = [String: Report]() {
        didSet {
            changed()
        }
    }

    private var _reportsByIdToSave = [String: Report]() {
        didSet {
            _saveReportsAfter = 2
        }
    }

    private var _reportsByIdToDelete = [String: Report]() {
        didSet {
            _saveReportsAfter = 2
        }
    }

    private var _saveReportsAfter = Int.max

    private let contentDirectory: NSString

    private var habitsFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/habits.plist")
    }

    private var habitsToSaveFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/habitsToSave.plist")
    }

    private var reportsFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/reports.plist")
    }

    private var reportsToSaveFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/reportsToSave.plist")
    }

    private var reportsToDeleteFilePath: String {
        return contentDirectory.stringByAppendingPathComponent("/reportsToDelete.plist")
    }

    public var changesObserver: ChangesObserver?

    init(contentDirectory: String) {
        self.contentDirectory = contentDirectory
        _habitsById = readHabitsFile(habitsFilePath)
        _habitsByIdToSave = readHabitsFile(habitsToSaveFilePath)
        _reportsById = readReportsFile(reportsFilePath)
        _reportsByIdToSave = readReportsFile(reportsToSaveFilePath)
        _reportsByIdToDelete = readReportsFile(reportsToDeleteFilePath)

        loadHabits()
        loadReports()

        _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction:", userInfo: nil, repeats: true)
        _timer.fire()
    }

    @objc private func timerAction(timer: NSTimer) {
        if _saveHabitsAfter <= 0 {
            _saveHabitsAfter = Int.max
            saveHabits()
        } else {
            _saveHabitsAfter--
        }

        if _saveReportsAfter <= 0 {
            _saveReportsAfter = Int.max
            saveReports()
        } else {
            _saveReportsAfter--
        }
    }

    private func changed() {
        changesObserver?.observableChanged(self)
    }

    // MARK: Caches

    private func readHabitsFile(fileName: String) -> [String:Habit] {
        guard let packedHabits = NSArray(contentsOfFile: fileName) else {
            return [String: Habit]()
        }
        var result = [String: Habit]()
        for packedHabit in packedHabits {
            if let dictionary = packedHabit as? [String:AnyObject], habit = Habit(packed: dictionary) {
                result[habit.id] = habit
            }
        }
        return result
    }

    private func writeHabits(habits: [String:Habit], fileName: String) -> Bool {
        let packedHabits = NSMutableArray()
        for habit in habits.values {
            packedHabits.addObject(habit.packed)
        }
        return packedHabits.writeToFile(habitsFilePath, atomically: true)
    }

    private func readReportsFile(fileName: String) -> [String:Report] {
        guard let packedReports = NSArray(contentsOfFile: fileName) else {
            return [String: Report]()
        }
        var result = [String: Report]()
        for packedReport in packedReports {
            if let dictionary = packedReport as? [String:AnyObject], report = Report(packed: dictionary) {
                result[report.id] = report
            }
        }
        return result
    }

    private func writeReports(reports: [String:Report], fileName: String) -> Bool {
        let packedReports = NSMutableArray()
        for report in reports.values {
            packedReports.addObject(report.packed)
        }
        return packedReports.writeToFile(reportsFilePath, atomically: true)
    }

    // MARK: Parse

    private func saveHabits() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            () -> Void in

            if self._habitsByIdToSave.count > 0 {
                let habitsByIdToSave = self._habitsByIdToSave
                var objectsToSave = [PFObject]()
                for habit in habitsByIdToSave.values {
                    self._habitsByIdToSave[habit.id] = nil
                    objectsToSave.append(habit.parseObject)
                }

                do {
                    print("try PFObject.saveAll(objectsToSave)")
                    try PFObject.saveAll(objectsToSave)
                } catch {
                    for habit in habitsByIdToSave.values {
                        self._habitsByIdToSave[habit.id] = habit
                    }
                    print("unable to save habits")
                }
            }
        }
    }

    private func loadHabits() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            () -> Void in

            let query = PFQuery(className: "Habit")
            if let objects = try? query.findObjects() {
                var habitsById = [String: Habit]()
                for object in objects {
                    if let habit = Habit(parseObject: object) {
                        habitsById[habit.id] = habit
                    }
                }

                if habitsById != self._habitsById {
                    self._habitsById = habitsById
                    self.writeHabits(self._habitsById, fileName: self.habitsFilePath)
                }
            }
        }
    }

    private func saveReports() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            () -> Void in

            if self._reportsByIdToSave.count > 0 {
                let reportsByIdToSave = self._reportsByIdToSave
                var objectsToSave = [PFObject]()
                for report in reportsByIdToSave.values {
                    self._reportsByIdToSave[report.id] = nil
                    objectsToSave.append(report.parseObject)
                }

                do {
                    print("try PFObject.saveAll(objectsToSave)")
                    try PFObject.saveAll(objectsToSave)
                } catch {
                    for report in reportsByIdToSave.values {
                        self._reportsByIdToSave[report.id] = report
                    }
                    print("unable to save reports")
                }
            }

            if self._reportsByIdToDelete.count > 0 {
                let reportsByIdToDelete = self._reportsByIdToDelete
                var objectsToDelete = [PFObject]()
                for report in reportsByIdToDelete.values {
                    self._reportsByIdToDelete[report.id] = nil
                    objectsToDelete.append(report.parseObject)
                }

                do {
                    print("try PFObject.deleteAll(objectsToSave)")
                    try PFObject.deleteAll(objectsToDelete)
                } catch {
                    for report in reportsByIdToDelete.values {
                        self._reportsByIdToDelete[report.id] = report
                    }
                    print("unable to delete reports")
                }
            }
        }
    }

    private func loadReports() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            () -> Void in

            let query = PFQuery(className: "Report")
            if let objects = try? query.findObjects() {
                var reportsById = [String: Report]()
                for object in objects {
                    if let report = Report(parseObject: object) {
                        reportsById[report.id] = report
                    }
                }

                if reportsById != self._reportsById {
                    self._reportsById = reportsById
                    self.writeReports(self._reportsById, fileName: self.reportsFilePath)
                }
            }
        }
    }
}

extension ParseStorage: DataProvider {

    var habits: [Habit] {
        return Array(_habitsById.values.filter {
            return $0.active
        })
    }

    func saveHabit(habit: Habit) -> Bool {
        let activeHabit = habit.activeHabit
        _habitsById[habit.id] = activeHabit
        _habitsByIdToSave[habit.id] = activeHabit
        return writeHabits(_habitsById, fileName: habitsFilePath)
    }

    func deleteHabit(habit: Habit) -> Bool {
        let inactiveHabit = habit.inactiveHabit
        _habitsById[habit.id] = inactiveHabit
        _habitsByIdToSave[habit.id] = inactiveHabit
        return writeHabits(_habitsById, fileName: habitsFilePath)
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
        _reportsByIdToSave[report.id] = report
        _reportsByIdToDelete[report.id] = nil
        return writeReports(_reportsById, fileName: reportsFilePath)
    }

    func deleteReport(report: Report) -> Bool {
        _reportsById[report.id] = nil
        _reportsByIdToSave[report.id] = nil
        _reportsByIdToDelete[report.id] = report
        return writeReports(_reportsById, fileName: reportsFilePath)
    }

    func reportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) -> [Report] {
        var result = [Report]()
        let fromTimeInterval = fromDate.timeIntervalSince1970
        let toTimeInterval = toDate.timeIntervalSince1970
        for report in _reportsById.values {
            let reportTimeInterval = report.date.timeIntervalSince1970
            if reportTimeInterval >= fromTimeInterval && reportTimeInterval < toTimeInterval {
                if let habit = habit {
                    if habit.name == report.habitName {
                        result.append(report)
                    }
                } else {
                    result.append(report)
                }
            }
        }
        return result
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