//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class Report: Equatable {
    let id: String
    let habitName: String
    let habitDefinition: String
    let habitRepeatsTotal: Int
    let repeatsDone: Int
    let date: NSDate

    init(id: String, habitName: String, habitDefinition: String, habitRepeatsTotal: Int, repeatsDone: Int, date: NSDate) {
        self.id = id
        self.habitName = habitName
        self.habitDefinition = habitDefinition
        self.habitRepeatsTotal = habitRepeatsTotal
        self.repeatsDone = repeatsDone
        self.date = date
    }

    convenience init(habitName: String, habitDefinition: String, habitRepeatsTotal: Int, repeatsDone: Int, date: NSDate) {
        self.init(id: "\(NSDate().timeIntervalSince1970)\(NSUUID().UUIDString)", habitName: habitName, habitDefinition: habitDefinition, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: repeatsDone, date: date)
    }

    convenience init(habit: Habit, repeatsDone: Int, date: NSDate) {
        self.init(habitName: habit.name, habitDefinition: habit.definition, habitRepeatsTotal: habit.repeatsTotal, repeatsDone: repeatsDone, date: date)
    }

    var completed: Bool {
        return habitRepeatsTotal == repeatsDone
    }

    var completedReport: Report {
        return Report(id: id, habitName: habitName, habitDefinition: habitDefinition, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: habitRepeatsTotal, date: date)
    }

    var incompletedReport: Report {
        return Report(id: id, habitName: habitName, habitDefinition: habitDefinition, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: 0, date: date)
    }
}

extension Report: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

extension Report: CustomStringConvertible {
    var description: String {
        return "<Report:id=\(id), habitName=\(habitName), habitRepeatsTotal=\(habitRepeatsTotal), repeatsDone:=\(repeatsDone), date=\(date)>"
    }
}

extension Report: CustomDebugStringConvertible {
    var debugDescription: String {
        return "<Report:id=\(id), habitName=\(habitName), habitRepeatsTotal=\(habitRepeatsTotal), repeatsDone:=\(repeatsDone), date=\(date)>"
    }
}

// MARK: - Equatable

func ==(lhs: Report, rhs: Report) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
