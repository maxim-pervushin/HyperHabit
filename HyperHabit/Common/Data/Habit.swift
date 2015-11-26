//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class Habit: Equatable {
    let id: String
    let name: String
    let repeatsTotal: Int

    init(id: String, name: String, repeatsTotal: Int) {
        self.id = id
        self.name = name
        self.repeatsTotal = repeatsTotal
    }

    init(name: String, repeatsTotal: Int) {
        self.id = "\(NSDate().timeIntervalSince1970)\(NSUUID().UUIDString)"
        self.name = name
        self.repeatsTotal = repeatsTotal
    }
}

extension Habit: Hashable {
    var hashValue: Int {
        return id.hashValue ^ name.hashValue /*^ repeatsTotal.hashValue*/
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
