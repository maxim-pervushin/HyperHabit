//
// Created by Maxim Pervushin on 24/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class HabitEditor {

    var changesObserver: ChangesObserver?

    var habit: Habit? {
        didSet {
            name = habit?.name
            if let habit = habit {
                repeatsTotal = habit.repeatsTotal
            } else {
                repeatsTotal = 1
            }
        }
    }

    var name: String? {
        didSet {
            changesObserver?.observableChanged(self)
        }
    }

    var definition: String? {
        didSet {
            changesObserver?.observableChanged(self)
        }
    }

    var repeatsTotal: Int? {
        didSet {
            changesObserver?.observableChanged(self)
        }
    }

    var updatedHabit: Habit? {
        guard
        let name = name?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),
        let repeatsTotal = repeatsTotal
        where name.characters.count > 0 && repeatsTotal > 0 else {
            return nil
        }

        if let habit = habit {
            return Habit(id: habit.id, name: name, definition: definition == nil ? "" : definition!, repeatsTotal: repeatsTotal, active: true)
        } else {
            return Habit(name: name, definition: definition == nil ? "" : definition!, repeatsTotal: repeatsTotal, active: true)
        }
    }

    var canSave: Bool {
        return updatedHabit != nil && updatedHabit != habit
    }
}
