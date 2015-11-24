//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class DataSource {

    internal var changesObserver: ChangesObserver?

    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        NSNotificationCenter.defaultCenter().addObserverForName(DataManager.changedNotification, object: self.dataManager, queue: nil) {
            (notification: NSNotification) -> Void in
            self.changesObserver?.observableChanged(self)
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataManager.changedNotification, object: nil)
    }
}
