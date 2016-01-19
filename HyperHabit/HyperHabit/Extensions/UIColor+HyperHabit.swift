//
// Created by Maxim Pervushin on 19/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

extension UIColor {

    var pixelImage: UIImage {
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