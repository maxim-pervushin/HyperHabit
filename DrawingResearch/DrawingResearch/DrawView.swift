//
//  DrawView.swift
//  DrawingResearch
//
//  Created by Maxim Pervushin on 19/01/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class DrawView: UIView {

    @IBInspectable var colors: [UIColor] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let numberOfSegments = colors.count
        if numberOfSegments == 0 {
            return
        }

        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, lineWidth)

        let borderRectSide = min(bounds.size.width, bounds.size.height) - 4
        let radius = (borderRectSide - borderRectSide / 4) / 2
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)


        print("----- start -----")

        let segmentSize = CGFloat(2.0 * M_PI) / CGFloat(numberOfSegments)
        let rotation = CGFloat(-0.5 * M_PI)

        var currentSegment = 0
        for color in colors {
            let startAngle = segmentSize * CGFloat(currentSegment) + rotation
            let endAngle = segmentSize * CGFloat(currentSegment + 1) + rotation
            print("startAngle:\(startAngle), endAngle:\(endAngle)")

            CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, 0)
            CGContextSetStrokeColor(ctx, CGColorGetComponents(color.CGColor))
            CGContextStrokePath(ctx)
            currentSegment++
        }
        print("----- end -----")
    }
}
