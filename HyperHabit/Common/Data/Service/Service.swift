//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

protocol Service {

    var changesObserver: ChangesObserver? { get set }

    var available: Bool { get }

    func getHabits() throws -> [Habit]

    func saveHabits(habits: [Habit]) throws

    func getReports() throws -> [Report]

    func saveReports(reports: [Report]) throws

    func deleteReports(reports: [Report]) throws

}
