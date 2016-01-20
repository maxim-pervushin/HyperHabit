//
// Created by Maxim Pervushin on 16/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class ThemePickerDataSource {

    var numberOfThemes: Int {
        return App.themeManager.themes.count
    }

    var currentTheme: Theme {
        get {
            return App.themeManager.theme
        }
        set {
            App.themeManager.theme = newValue
        }
    }

    func themeAtIndex(index: Int) -> Theme {
        return App.themeManager.themes[index]
    }
}
