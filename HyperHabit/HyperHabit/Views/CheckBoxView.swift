//
// Created by Maxim Pervushin on 11/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class CheckboxView: UIView {

    @IBInspectable var checked: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {

        let ctx = UIGraphicsGetCurrentContext()

        // Draw border circle
        let borderRectSide = min(bounds.size.width, bounds.size.height) - 4
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        let borderRect = CGRectMake(center.x - borderRectSide / 2, center.y - borderRectSide / 2, borderRectSide, borderRectSide)
        CGContextAddEllipseInRect(ctx, borderRect)
        CGContextSetStrokeColor(ctx, CGColorGetComponents(tintColor.CGColor))
        CGContextStrokePath(ctx)

        if checked {
            // Draw internal circle
            let internalRectSide = borderRectSide - borderRectSide / 4
            let internalRect = CGRectMake(center.x - internalRectSide / 2, center.y - internalRectSide / 2, internalRectSide, internalRectSide)
            CGContextAddEllipseInRect(ctx, internalRect)
            CGContextSetFillColor(ctx, CGColorGetComponents(tintColor.CGColor))
            CGContextFillPath(ctx)
        }

    }
}
