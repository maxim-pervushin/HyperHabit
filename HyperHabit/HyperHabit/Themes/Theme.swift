//
// Created by Maxim Pervushin on 15/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

struct Theme: Equatable {

    let identifier: String
    let name: String
    let dark: Bool
    let backgroundColor: UIColor
    let foregroundColor: UIColor

    init(identifier: String, name: String, dark: Bool, backgroundColor: UIColor, foregroundColor: UIColor) {
        self.identifier = identifier
        self.name = name
        self.dark = dark
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
}

extension Theme {

    var statusBarStyle: UIStatusBarStyle {
        return dark ? .LightContent : .Default
    }

    var barStyle: UIBarStyle {
//        return dark ? .Black : .Default
        return .Black
    }

    var barBackgroundImage: UIImage {
        return backgroundColor.image
    }

    var textColor: UIColor {
        return foregroundColor
    }

    var inactiveTextColor: UIColor {
        return foregroundColor.colorWithAlphaComponent(0.2)
    }
}

// MARK: - Equatable

func ==(lhs: Theme, rhs: Theme) -> Bool {
    return lhs.identifier == rhs.identifier
}
