//
// Created by Maxim Pervushin on 23/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.textRectForBounds(bounds)
        print("\(rect) = textRectForBounds(\(bounds)")
        return rect
    }

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.textRectForBounds(bounds)
        print("\(rect) = placeholderRectForBounds(\(bounds)")
        return rect
    }



    override func drawPlaceholderInRect(rect: CGRect) {
        if let placeholder = placeholder {
            var attributes = defaultTextAttributes
            attributes[NSForegroundColorAttributeName] = UIColor.greenColor()
            placeholder.drawInRect(rect, withAttributes: attributes)
        }
//        let ctx = UIGraphicsGetCurrentContext()
//        CGContextSetStrokeColorWithColor(ctx, UIColor.greenColor().CGColor)
//        super.drawPlaceholderInRect(rect)
    }

}
