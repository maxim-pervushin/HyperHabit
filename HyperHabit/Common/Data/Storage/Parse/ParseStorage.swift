//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

// TODO: Make class independent from ParseService and PlistCache.
// TODO: Rename to DataManager.

class ParseStorage {

    private let service: ParseService
    private let cache: PlistCache
    private var timer: NSTimer!

    private var saveHabitsAfter = Int.max
    private var saveReportsAfter = Int.max

    var changesObserver: ChangesObserver?

    init(contentDirectory: String) {
        cache = PlistCache(contentDirectory: contentDirectory)
        service = ParseService()

        loadHabits()
        loadReports()

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction:", userInfo: nil, repeats: true)
        timer.fire()
    }

    @objc private func timerAction(timer: NSTimer) {
        if saveHabitsAfter <= 0 {
            saveHabitsAfter = Int.max
            saveHabits()
        } else {
            saveHabitsAfter--
        }

        if saveReportsAfter <= 0 {
            saveReportsAfter = Int.max
            saveReports()
        } else {
            saveReportsAfter--
        }
    }

    private func changed() {
        changesObserver?.observableChanged(self)
        NSNotificationCenter.defaultCenter().postNotificationName(DataManager.changedNotification, object: self)
    }

    // MARK: Parse

    private func saveHabits() {

        if !service.available {
            return
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            () -> Void in

            if self.cache.habitsByIdToSave.count == 0 {
                return
            }

            let habits = self.cache.habitsByIdToSave.values
            // Remove selected habits from habits-to-save to avoid save attempt from another thread
            for habit in habits {
                self.cache.habitsByIdToSave[habit.id] = nil
            }

            do {
                try self.service.saveHabits(Array(habits))
            } catch {
                // Put habits-to-save back if something goes wrong
                for habit in habits {
                    self.cache.habitsByIdToSave[habit.id] = habit
                }
                print("ERROR: Unable to save habits")
            }
        }
    }

    private func loadHabits() {

        if !service.available {
            return
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let habits = try self.service.getHabits()
                var habitsById = [String: Habit]()
                for habit in habits {
                    habitsById[habit.id] = habit
                }
                self.cache.habitsById = habitsById
                self.changed()
            } catch {
                print("ERROR: Unable to load habits")
            }
        }
    }

    private func saveReports() {

        if !service.available {
            return
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {

            if self.cache.reportsByIdToSave.count == 0 {
                return
            }

            let reports = self.cache.reportsByIdToSave.values
            // Remove selected reports from reports-to-save to avoid save attempt from another thread
            for report in reports {
                self.cache.reportsByIdToSave[report.id] = nil
            }

            do {
                try self.service.saveReports(Array(reports))
            } catch {
                // Put reports-to-save back if something goes wrong
                for report in reports {
                    self.cache.reportsByIdToSave[report.id] = report
                }
                print("ERROR: Unable to save reports")
            }
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {

            if self.cache.reportsByIdToDelete.count == 0 {
                return
            }

            let reports = self.cache.reportsByIdToDelete.values
            // Remove selected reports from reports-to-delete to avoid delete attempt from another thread
            for report in reports {
                self.cache.reportsByIdToDelete[report.id] = nil
            }

            do {
                try self.service.deleteReports(Array(reports))
            } catch {
                // Put reports-to-delete back if something goes wrong
                for report in reports {
                    self.cache.reportsByIdToDelete[report.id] = report
                }
                print("ERROR: Unable to delete reports")
            }
        }
    }

    private func loadReports() {

        if !service.available {
            return
        }

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let reports = try self.service.getReports()
                var reportsById = [String: Report]()
                for report in reports {
                    reportsById[report.id] = report
                }
                self.cache.reportsById = reportsById
                self.changed()
            } catch {
                print("ERROR: Unable to load reports")
            }
        }
    }
}

extension ParseStorage: DataProvider {

    var habits: [Habit] {
        return Array(cache.habitsById.values.filter {
            return $0.active
        })
    }

    func saveHabit(habit: Habit) -> Bool {
        let activeHabit = habit.activeHabit
        cache.habitsById[habit.id] = activeHabit
        cache.habitsByIdToSave[habit.id] = activeHabit
        saveHabitsAfter = 2
        changed()
        return true
    }

    func deleteHabit(habit: Habit) -> Bool {
        let inactiveHabit = habit.inactiveHabit
        cache.habitsById[habit.id] = inactiveHabit
        cache.habitsByIdToSave[habit.id] = inactiveHabit
        saveHabitsAfter = 2
        changed()
        return true
    }

    var reports: [Report] {
        return Array(cache.reportsById.values)
    }

    func reportsForDate(date: NSDate) -> [Report] {
        let dateComponent = date.dateComponent
        return Array(cache.reportsById.values.filter {
            return $0.date.dateComponent == dateComponent
        })
    }

    func saveReport(report: Report) -> Bool {
        cache.reportsById[report.id] = report
        cache.reportsByIdToSave[report.id] = report
        cache.reportsByIdToDelete[report.id] = nil
        saveReportsAfter = 2
        changed()
        return true
    }

    func deleteReport(report: Report) -> Bool {
        cache.reportsById[report.id] = nil
        cache.reportsByIdToSave[report.id] = nil
        cache.reportsByIdToDelete[report.id] = report
        saveReportsAfter = 2
        changed()
        return true
    }

    func reportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) -> [Report] {
        var result = [Report]()
        let fromTimeInterval = fromDate.timeIntervalSince1970
        let toTimeInterval = toDate.timeIntervalSince1970
        for report in cache.reportsById.values {
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
