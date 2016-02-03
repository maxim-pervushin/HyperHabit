//
// Created by Maxim Pervushin on 23/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class TextField: UITextField {

    private var _placeholderTextColor = UIColor.darkGrayColor()

    override func drawPlaceholderInRect(rect: CGRect) {
        if let placeholder = placeholder {
            var attributes = defaultTextAttributes
            attributes[NSForegroundColorAttributeName] = _placeholderTextColor
            attributes[NSFontAttributeName] = font
            let boundingRect = placeholder.boundingRectWithSize(rect.size, options: [], attributes: attributes, context: nil)
            placeholder.drawAtPoint(CGPointMake(0, (rect.size.height / 2) - boundingRect.size.height / 2), withAttributes: attributes)
        }
    }
}

extension TextField {

    // MARK: - UIAppearance

    dynamic var placeholderTextColor: UIColor {
        // UI_APPEARANCE_SELECTOR
        get {
            return _placeholderTextColor
        }
        set {
            _placeholderTextColor = newValue
        }
    }
}