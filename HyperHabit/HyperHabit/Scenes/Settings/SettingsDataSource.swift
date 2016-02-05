//
// Created by Maxim Pervushin on 26/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

class SettingsDataSource {

    func clearCache() {
        if let dataManager = App.dataProvider as? DataManager {
            dataManager.clearCache()
        }
    }
}
