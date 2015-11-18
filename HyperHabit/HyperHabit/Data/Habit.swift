//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Habit {
    let name: String
    let repeatsTotal: Int

    init(name: String, repeatsTotal: Int) {
        self.name = name
        self.repeatsTotal = repeatsTotal
    }
}
