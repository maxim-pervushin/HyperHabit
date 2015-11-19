//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Report: Equatable {
    let habitName: String
    let habitRepeatsTotal: Int
    let repeatsDone: Int
    let date: NSDate

    init(habitName: String, habitRepeatsTotal: Int, repeatsDone: Int, date: NSDate) {
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
        // TODO: don't use full date
        return "\(habitName)\(habitRepeatsTotal)\(habitRepeatsTotal)\(date)".hashValue
    }
}

// MARK: - Equatable

func ==(lhs: Report, rhs: Report) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
