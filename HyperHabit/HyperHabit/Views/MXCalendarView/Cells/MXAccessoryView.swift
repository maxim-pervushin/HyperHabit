//
// Created by Maxim Pervushin on 19/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class MXAccessoryView: UIView {

    @IBInspectable var value: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var maxValue: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var _activeSegmentColor = UIColor.clearColor()
    private var _inactiveSegmentColor = UIColor.clearColor()


    override func drawRect(rect: CGRect) {
        if maxValue == 0 {
            return
        }

        let ctx = UIGraphicsGetCurrentContext()
        let borderRectSide = min(bounds.size.width, bounds.size.height) - 4
        let radius = (borderRectSide - borderRectSide / 6) / 2
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)

        let segmentSize = CGFloat(2.0 * M_PI) / CGFloat(maxValue)
        let rotation = CGFloat(-0.5 * M_PI)

        for currentSegment in 0 ... maxValue - 1 {
            let startAngle = segmentSize * CGFloat(currentSegment) + rotation
            let endAngle = segmentSize * CGFloat(currentSegment + 1) + rotation
            CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, 0)
            CGContextSetStrokeColorWithColor(ctx, (currentSegment < value ? _activeSegmentColor : _inactiveSegmentColor).CGColor)
            CGContextStrokePath(ctx)
        }
    }
}

extension MXAccessoryView {

    // MARK: - UIAppearance

    dynamic var activeSegmentColor: UIColor {
        // UI_APPEARANCE_SELECTOR
        get {
            return _activeSegmentColor
        }
        set {
            _activeSegmentColor = newValue
        }
    }

    dynamic var inactiveSegmentColor: UIColor {
        // UI_APPEARANCE_SELECTOR
        get {
            return _inactiveSegmentColor
        }
        set {
            _inactiveSegmentColor = newValue
        }
    }
}