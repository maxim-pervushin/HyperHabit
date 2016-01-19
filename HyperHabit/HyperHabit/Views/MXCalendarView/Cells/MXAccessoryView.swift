//
// Created by Maxim Pervushin on 19/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class MXAccessoryView: UIView {

    @IBInspectable var color: UIColor = UIColor.clearColor() {
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
        CGContextSetStrokeColor(ctx, CGColorGetComponents(color.CGColor))
        CGContextStrokePath(ctx)
    }
}
