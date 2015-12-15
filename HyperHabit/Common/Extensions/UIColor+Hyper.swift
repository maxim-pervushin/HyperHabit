//
// Created by Maxim Pervushin on 15/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

extension UIColor {

    // https://github.com/bfeher/BFPaperColors
    var brightness: CGFloat {
        let components = CGColorGetComponents(self.CGColor)
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114))
        return brightness / 1000
    }

    // https://github.com/bfeher/BFPaperColors
    var isDark: Bool {
        return brightness < 0.5
    }

    // 1x1 UIImage object with given color
    var image: UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}