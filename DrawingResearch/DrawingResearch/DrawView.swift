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
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, 3)
        
        // Draw border circle
        let borderRectSide = min(bounds.size.width, bounds.size.height) - 4
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
//        let borderRect = CGRectMake(center.x - borderRectSide / 2, center.y - borderRectSide / 2, borderRectSide, borderRectSide)
        //CGContextAddEllipseInRect(ctx, borderRect)
        //CGContextSetStrokeColor(ctx, CGColorGetComponents(color.CGColor))
        //CGContextStrokePath(ctx)

        
        print("----- start -----")
        let numberOfSegments = colors.count
        if numberOfSegments == 0 {
            return
        }
        var segmentSize = CGFloat(2) * CGFloat(M_PI) / CGFloat(numberOfSegments)
        var currentSegment = 0
        for color in colors {
            let startAngle =  segmentSize * CGFloat(currentSegment)
            let endAngle =  segmentSize * CGFloat(currentSegment + 1)
            print("startAngle:\(startAngle), endAngle:\(endAngle)")
            CGContextAddArc(ctx, center.x, center.y, borderRectSide / 2, startAngle, endAngle, 1)
            CGContextSetStrokeColor(ctx, CGColorGetComponents(color.CGColor))
            CGContextStrokePath(ctx)

            currentSegment++
        }
        
//        for index in 0...numberOfSegments {
//            print("index: \(index)")
//        }
        print("----- end -----")
    }
}
