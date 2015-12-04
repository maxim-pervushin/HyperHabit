//
// Created by Maxim Pervushin on 03/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

// TODO: Add file monitoring. Something like DTFolderMonitor.

class PlistCache {

    // MARK: PlistCache public

    init(contentDirectory: String) {
        self.contentDirectory = contentDirectory
    }

    // MARK: PlistCache private

    private let contentDirectory: NSString
    private let cache = NSCache()

    private let habitsFileName = "habits"
    private let habitsToSaveFileName = "habitsToSave"
    private let reportsFileName = "reports"
    private let reportsToSaveFileName = "reportsToSave"
    private let reportsToDeleteFileName = "reportsToDelete"

    private func readHabitsFile(fileName: String) -> [String:Habit] {
        if let cached = cache.objectForKey(fileName) as? [String:Habit] {
            return cached
        }

        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        guard let packedHabits = NSArray(contentsOfFile: filePath) else {
            return [String: Habit]()
        }
        var result = [String: Habit]()
        for packedHabit in packedHabits {
            if let dictionary = packedHabit as? [String:AnyObject], habit = Habit(packed: dictionary) {
                result[habit.id] = habit
            }
        }

        cache.setObject(result, forKey: fileName)

        return result
    }

    private func writeHabits(habits: [String:Habit], fileName: String) -> Bool {
        cache.removeObjectForKey(fileName)

        let packedHabits = NSMutableArray()
        for habit in habits.values {
            packedHabits.addObject(habit.packed)
        }
        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        return packedHabits.writeToFile(filePath, atomically: true)
    }

    private func readReportsFile(fileName: String) -> [String:Report] {
        if let cached = cache.objectForKey(fileName) as? [String:Report] {
            return cached
        }

        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        guard let packedReports = NSArray(contentsOfFile: filePath) else {
            return [String: Report]()
        }
        var result = [String: Report]()
        for packedReport in packedReports {
            if let dictionary = packedReport as? [String:AnyObject], report = Report(packed: dictionary) {
                result[report.id] = report
            }
        }

        cache.setObject(result, forKey: fileName)

        return result
    }

    private func writeReports(reports: [String:Report], fileName: String) -> Bool {
        cache.removeObjectForKey(fileName)

        let packedReports = NSMutableArray()
        for report in reports.values {
            packedReports.addObject(report.packed)
        }

        let filePath = contentDirectory.stringByAppendingPathComponent("/\(fileName).plist")
        return packedReports.writeToFile(filePath, atomically: true)
    }
}

extension PlistCache: Cache {

    var habitsById: [String:Habit] {
        get {
            return readHabitsFile(habitsFileName)
        }
        set {
            writeHabits(newValue, fileName: habitsFileName)
        }
    }

    var habitsByIdToSave: [String:Habit] {
        get {
            return readHabitsFile(habitsToSaveFileName)
        }
        set {
            writeHabits(newValue, fileName: habitsToSaveFileName)
        }
    }

    var reportsById: [String:Report] {
        get {
            return readReportsFile(reportsFileName)
        }
        set {
            writeReports(newValue, fileName: reportsFileName)
        }
    }

    var reportsByIdToSave: [String:Report] {
        get {
            return readReportsFile(reportsToSaveFileName)
        }
        set {
            writeReports(newValue, fileName: reportsToSaveFileName)
        }
    }

    var reportsByIdToDelete: [String:Report] {
        get {
            return readReportsFile(reportsToDeleteFileName)
        }
        set {
            writeReports(newValue, fileName: reportsToDeleteFileName)
        }
    }
}