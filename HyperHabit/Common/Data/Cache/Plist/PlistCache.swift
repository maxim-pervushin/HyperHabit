//
// Created by Maxim Pervushin on 03/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class PlistCache {

    // MARK: PlistCache public

    init(contentDirectory: String) {
        self.contentDirectory = contentDirectory
        folderMonitor = DTFolderMonitor(forURL: NSURL(fileURLWithPath: contentDirectory, isDirectory: true), block: changed)
        folderMonitor.startMonitoring()
    }

    deinit {
        folderMonitor.stopMonitoring()
    }

    // MARK: PlistCache private

    private let contentDirectory: NSString
    private let cache = NSCache()
    private var folderMonitor: DTFolderMonitor!

    private let habitsFileName = "habits"
    private let habitsToSaveFileName = "habitsToSave"
    private let reportsFileName = "reports"
    private let reportsToSaveFileName = "reportsToSave"
    private let reportsToDeleteFileName = "reportsToDelete"

    private func changed() {
        cache.removeAllObjects()
        // TODO: Don't send DataManager.changedNotification from here, use changesObserver
        // TODO: Move changes observer to 'Cache'
        NSNotificationCenter.defaultCenter().postNotificationName(DataManager.changedNotification, object: self)
    }

    private func readHabitsFile(fileName: String) -> [Habit] {
        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        guard let packedHabits = NSArray(contentsOfFile: filePath) else {
            return []
        }
        var result = [Habit]()
        for packedHabit in packedHabits {
            if let dictionary = packedHabit as? [String:AnyObject], habit = Habit(packed: dictionary) {
                result.append(habit)
            }
        }

        return result
    }

    private func writeHabits(habits: [Habit], fileName: String) -> Bool {
        let packedHabits = NSMutableArray()
        for habit in habits {
            packedHabits.addObject(habit.packed)
        }
        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        return packedHabits.writeToFile(filePath, atomically: true)
    }

    private func readReportsFile(fileName: String) -> [Report] {
        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        guard let packedReports = NSArray(contentsOfFile: filePath) else {
            return []
        }
        var result = [Report]()
        for packedReport in packedReports {
            if let dictionary = packedReport as? [String:AnyObject], report = Report(packed: dictionary) {
                result.append(report)
            }
        }

        return result
    }

    private func writeReports(reports: [Report], fileName: String) -> Bool {
        let packedReports = NSMutableArray()
        for report in reports {
            packedReports.addObject(report.packed)
        }

        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        return packedReports.writeToFile(filePath, atomically: true)
    }
}

extension PlistCache: Cache {

    var habitsById: [String:Habit] {
        get {
            let cacheKey = "habitsById"
            if let cached = cache.objectForKey(cacheKey) as? [String:Habit] {
                return cached
            }

            var result = [String: Habit]()
            let habits = readHabitsFile(habitsFileName)
            for habit in habits {
                result[habit.id] = habit
            }
            let habitsToSave = readHabitsFile(habitsToSaveFileName)
            for habit in habitsToSave {
                result[habit.id] = habit
            }

            cache.setObject(result, forKey: cacheKey)
            return result
        }
        set {
            cache.removeObjectForKey("habitsById")
            writeHabits(Array(newValue.values), fileName: habitsFileName)
        }
    }

    var habitsByIdToSave: [String:Habit] {
        get {
            let cacheKey = "habitsByIdToSave"
            if let cached = cache.objectForKey(cacheKey) as? [String:Habit] {
                return cached
            }

            var result = [String: Habit]()
            let habitsToSave = readHabitsFile(habitsToSaveFileName)
            for habit in habitsToSave {
                result[habit.id] = habit
            }

            cache.setObject(result, forKey: cacheKey)
            return result
        }
        set {
            cache.removeObjectForKey("habitsById")
            cache.removeObjectForKey("habitsByIdToSave")
            writeHabits(Array(newValue.values), fileName: habitsToSaveFileName)
        }
    }

    var reportsById: [String:Report] {
        get {
            let cacheKey = "reportsById"
            if let cached = cache.objectForKey(cacheKey) as? [String:Report] {
                return cached
            }

            var result = [String: Report]()
            let reports = readReportsFile(reportsFileName)
            for report in reports {
                result[report.id] = report
            }
            let reportsToSave = readReportsFile(reportsToSaveFileName)
            for report in reportsToSave {
                result[report.id] = report
            }
            let reportsToDelete = readReportsFile(reportsToDeleteFileName)
            for report in reportsToDelete {
                result[report.id] = nil
            }

            cache.setObject(result, forKey: cacheKey)
            return result
        }
        set {
            cache.removeObjectForKey("reportsById")
            writeReports(Array(newValue.values), fileName: reportsFileName)
        }
    }

    var reportsByIdToSave: [String:Report] {
        get {
            let cacheKey = "reportsByIdToSave"
            if let cached = cache.objectForKey(cacheKey) as? [String:Report] {
                return cached
            }

            var result = [String: Report]()
            let reportsToSave = readReportsFile(reportsToSaveFileName)
            for report in reportsToSave {
                result[report.id] = report
            }

            cache.setObject(result, forKey: cacheKey)
            return result
        }
        set {
            cache.removeObjectForKey("reportsById")
            cache.removeObjectForKey("reportsByIdToSave")
            writeReports(Array(newValue.values), fileName: reportsToSaveFileName)
        }
    }

    var reportsByIdToDelete: [String:Report] {
        get {
            let cacheKey = "reportsByIdToDelete"
            if let cached = cache.objectForKey(cacheKey) as? [String:Report] {
                return cached
            }

            var result = [String: Report]()
            let reportsToDelete = readReportsFile(reportsToDeleteFileName)
            for report in reportsToDelete {
                result[report.id] = report
            }

            cache.setObject(result, forKey: cacheKey)
            return result
        }
        set {
            cache.removeObjectForKey("reportsById")
            cache.removeObjectForKey("reportsByIdToDelete")
            writeReports(Array(newValue.values), fileName: reportsToDeleteFileName)
        }
    }

    func clear() {
        habitsById = [String: Habit]()
        habitsByIdToSave = [String: Habit]()
        reportsById = [String: Report]()
        reportsByIdToSave = [String: Report]()
        reportsByIdToDelete = [String: Report]()
    }
}