//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Habit: Equatable {
    let name: String
    let repeatsTotal: Int

    init(name: String, repeatsTotal: Int) {
        self.name = name
        self.repeatsTotal = repeatsTotal
    }
}

extension Habit: Hashable {
    var hashValue: Int {
        return "\(name)\(repeatsTotal)".hashValue
    }
}

// MARK: - Equatable

func ==(lhs: Habit, rhs: Habit) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
