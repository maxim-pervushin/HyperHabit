//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

// TODO: Add clear function.
// TODO: Add changes observer.

protocol Cache {

    var habitsById: [String:Habit] { get set }

    var habitsByIdToSave: [String:Habit] { get set }

    var reportsById: [String:Report] { get set }

    var reportsByIdToSave: [String:Report] { get set }

    var reportsByIdToDelete: [String:Report] { get set }
}
