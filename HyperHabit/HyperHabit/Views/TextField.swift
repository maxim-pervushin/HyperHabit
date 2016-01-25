//
// Created by Maxim Pervushin on 23/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class TextField: UITextField {

//    override var placeholder: String? {
//        didSet {
//            guard let placeholder = placeholder else {
//                attributedPlaceholder = nil
//                return
//            }
//            var attributes = defaultTextAttributes
//            attributes[NSForegroundColorAttributeName] = UIColor.greenColor()
//            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
//            setNeedsDisplay()
//            self.placeholder = nil
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if let placeholderText = placeholder {
//            placeholder = nil
            var attributes = defaultTextAttributes
            attributes[NSForegroundColorAttributeName] = UIColor.greenColor()
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
    }


//    override func textRectForBounds(bounds: CGRect) -> CGRect {
////        let rect = super.textRectForBounds(bounds)
////        print("\(rect) = textRectForBounds(\(bounds)")
////        return rect
//        return rectForBounds(bounds)
//    }
//
//    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
////        let rect = super.textRectForBounds(bounds)
////        print("\(rect) = placeholderRectForBounds(\(bounds)")
////        return rect
//        return rectForBounds(bounds)
//    }
//
//    private func rectForBounds(bounds: CGRect) -> CGRect {
//        let rect = CGRectInset(bounds, 10, 5)
//        print("\(rect) = rectForBounds(\(bounds))")
//        return rect
//    }
//
//    override func drawPlaceholderInRect(rect: CGRect) {
//        if let placeholder = placeholder {
//            var attributes = defaultTextAttributes
//            attributes[NSForegroundColorAttributeName] = UIColor.greenColor()
//            placeholder.drawInRect(rect, withAttributes: attributes)
//
//            placeholder.si
//        }
////        let ctx = UIGraphicsGetCurrentContext()
////        CGContextSetStrokeColorWithColor(ctx, UIColor.greenColor().CGColor)
////        super.drawPlaceholderInRect(rect)
//    }

}
