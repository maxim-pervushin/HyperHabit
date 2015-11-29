//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

// TODO: This class far from perfect. Need to rewrite it ever.
// TODO: Should be able to fetch data from Parse without re-initialization.

class ParseStorage {

    private let service = ParseService()
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

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in

            if self._habitsByIdToSave.count == 0 {
                return
            }

            let habits = self._habitsByIdToSave.values
            // Remove selected habits from habits-to-save to avoid save attempt from another thread
            for habit in habits {
                self._habitsByIdToSave[habit.id] = nil
            }

            do {
                try self.service.saveHabits(Array(habits))
            } catch {
                // Put habits-to-save back if something goes wrong
                for habit in habits {
                    self._habitsByIdToSave[habit.id] = habit
                }
                print("ERROR: Unable to save habits")
            }
        }
    }

    private func loadHabits() {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in
            do {
                let habits = try self.service.getHabits()
                var habitsById = [String: Habit]()
                for habit in habits {
                    habitsById[habit.id] = habit
                }
                self._habitsById = habitsById
                self.writeHabits(self._habitsById, fileName: self.habitsFilePath)
            } catch {
                print("ERROR: Unable to load habits")
            }
        }
    }

    private func saveReports() {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in

            if self._reportsByIdToSave.count == 0 {
                return
            }

            let reports = self._reportsByIdToSave.values
            // Remove selected reports from reports-to-save to avoid save attempt from another thread
            for report in reports {
                self._reportsByIdToSave[report.id] = nil
            }

            do {
                try self.service.saveReports(Array(reports))
            } catch {
                // Put reports-to-save back if something goes wrong
                for report in reports {
                    self._reportsByIdToSave[report.id] = report
                }
                print("ERROR: Unable to save reports")
            }
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in

            if self._reportsByIdToDelete.count == 0 {
                return
            }

            let reports = self._reportsByIdToDelete.values
            // Remove selected reports from reports-to-delete to avoid delete attempt from another thread
            for report in reports {
                self._reportsByIdToDelete[report.id] = nil
            }

            do {
                try self.service.deleteReports(Array(reports))
            } catch {
                // Put reports-to-delete back if something goes wrong
                for report in reports {
                    self._reportsByIdToDelete[report.id] = report
                }
                print("ERROR: Unable to delete reports")
            }
        }
    }

    private func loadReports() {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in
            do {
                let reports = try self.service.getReports()
                var reportsById = [String: Report]()
                for report in reports {
                    reportsById[report.id] = report
                }
                self._reportsById = reportsById
                self.writeReports(self._reportsById, fileName: self.reportsFilePath)
            } catch {
                print("ERROR: Unable to load reports")
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
