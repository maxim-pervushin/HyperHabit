//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class Habit: Equatable {
    let id: String
    let name: String
    let definition: String
    let repeatsTotal: Int
    let active: Bool

    init(id: String, name: String, definition: String, repeatsTotal: Int, active: Bool) {
        self.id = id
        self.name = name
        self.definition = definition
        self.repeatsTotal = repeatsTotal
        self.active = active
    }

    convenience init(name: String, definition: String, repeatsTotal: Int, active: Bool) {
        self.init(id: "\(NSDate().timeIntervalSince1970)\(NSUUID().UUIDString)", name: name, definition: definition, repeatsTotal: repeatsTotal, active: active)
    }

    var inactiveHabit: Habit {
        return Habit(id: id, name: name, definition: definition, repeatsTotal: repeatsTotal, active: false)
    }

    var activeHabit: Habit {
        return Habit(id: id, name: name, definition: definition, repeatsTotal: repeatsTotal, active: true)
    }
}

extension Habit: Hashable {
    var hashValue: Int {
        return id.hashValue ^ name.hashValue
    }
}

extension Habit: CustomStringConvertible {
    var description: String {
        return "<Habit:id=\(id), name=\(name), repeatsTotal=\(repeatsTotal)>"
    }
}

extension Habit: CustomDebugStringConvertible {
    var debugDescription: String {
        return "<Habit:id=\(id), name=\(name), repeatsTotal=\(repeatsTotal)>"
    }
}

// MARK: - Equatable

func ==(lhs: Habit, rhs: Habit) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
