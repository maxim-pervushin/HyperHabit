//
//  CheckboxView.swift
//  CheckboxResearch
//
//  Created by Maxim Pervushin on 10/02/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class CheckboxView: UIView {

    @IBInspectable var total: Int = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var current: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var _color: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    dynamic var color: UIColor {
        set {
            _color = newValue
        }
        get {
            return _color
        }
    }

    override func drawRect(rect: CGRect) {

        let ctx = UIGraphicsGetCurrentContext()

        // Draw border circle
        let borderRectSide = min(bounds.size.width, bounds.size.height) - 4
        let center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        let borderRect = CGRectMake(center.x - borderRectSide / 2, center.y - borderRectSide / 2, borderRectSide, borderRectSide)
        CGContextSetFillColor(ctx, CGColorGetComponents(_color.colorWithAlphaComponent(0.5).CGColor))
        CGContextFillEllipseInRect(ctx, borderRect)
        CGContextFillPath(ctx)

        if current > 0 {
            // Draw section
            let internalRectSide = borderRectSide
            let internalRect = CGRectMake(center.x - internalRectSide / 2, center.y - internalRectSide / 2, internalRectSide, internalRectSide)
            let radius = internalRectSide / 2

            let segmentSize = CGFloat(2.0 * M_PI) / CGFloat(total)
            let rotation = CGFloat(-0.5 * M_PI)

            let startAngle = segmentSize * 0 + rotation
            let endAngle = segmentSize * CGFloat(current) + rotation

            CGContextMoveToPoint(ctx, center.x, center.y)

            CGContextSetFillColor(ctx, CGColorGetComponents(_color.CGColor))
            CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, 0)
            CGContextFillPath(ctx)
        }
    }

    private func incCurrent() {
        var newCurrent = current + 1
        if newCurrent > total {
            newCurrent = 0
        }
        current = newCurrent
    }

    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            incCurrent()
        }
    }

    private func commonInit() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
        backgroundColor = UIColor.clearColor()

        _color = UIColor(red:0.17, green:0.24, blue:0.32, alpha:1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
