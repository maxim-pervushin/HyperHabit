//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Report: Equatable {
    let id: String
    let habitName: String
    let habitRepeatsTotal: Int
    let repeatsDone: Int
    let date: NSDate

    init(id: String, habitName: String, habitRepeatsTotal: Int, repeatsDone: Int, date: NSDate) {
        self.id = id
        self.habitName = habitName
        self.habitRepeatsTotal = habitRepeatsTotal
        self.repeatsDone = repeatsDone
        self.date = date
    }

    init(habitName: String, habitRepeatsTotal: Int, repeatsDone: Int, date: NSDate) {
        self.id = "\(NSDate().timeIntervalSince1970)\(NSUUID().UUIDString)"
        self.habitName = habitName
        self.habitRepeatsTotal = habitRepeatsTotal
        self.repeatsDone = repeatsDone
        self.date = date
    }

    init(habit: Habit, repeatsDone: Int, date: NSDate) {
        self.init(habitName: habit.name, habitRepeatsTotal: habit.repeatsTotal, repeatsDone: repeatsDone, date: date)
    }

}

extension Report: Hashable {
    var hashValue: Int {
        return id.hashValue ^ habitName.hashValue ^ habitRepeatsTotal.hashValue ^ repeatsDone.hashValue ^ date.dateComponent.hashValue
    }
}

// MARK: - Equatable

func ==(lhs: Report, rhs: Report) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
