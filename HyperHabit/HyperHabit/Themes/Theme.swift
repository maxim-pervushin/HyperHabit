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

    static var pixelSize: CGFloat {
        return 1.0 / UIScreen.mainScreen().scale
    }

    var statusBarStyle: UIStatusBarStyle {
        return dark ? .LightContent : .Default
    }

    var barStyle: UIBarStyle {
//        return dark ? .Black : .Default
        return .Black
    }

    var topBarBackgroundImage: UIImage {
        let rect = CGRectMake(0, 0, 5, 5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, rect)
        CGContextSetFillColorWithColor(context, foregroundColor.colorWithAlphaComponent(0.25).CGColor)
        CGContextSetShouldAntialias(context, false)
        CGContextFillRect(context, CGRectMake(0, rect.size.height - Theme.pixelSize, 5, Theme.pixelSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 1, 0), resizingMode: .Stretch)
    }

    var bottomBarBackgroundImage: UIImage {
        let rect = CGRectMake(0, 0, 5, 5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, rect)

        CGContextSetFillColorWithColor(context, foregroundColor.colorWithAlphaComponent(0.25).CGColor)

        CGContextSetShouldAntialias(context, false)
        CGContextFillRect(context, CGRectMake(0, 0, 5, Theme.pixelSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image.resizableImageWithCapInsets(UIEdgeInsetsMake(1, 0, 0, 0), resizingMode: .Stretch)
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
