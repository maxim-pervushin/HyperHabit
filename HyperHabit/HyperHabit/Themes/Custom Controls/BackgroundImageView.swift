//
// Created by Maxim Pervushin on 19/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundImageView: UIView {

    static let backgroundImage = UIImage(named: "Background")

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let image = BackgroundImageView.backgroundImage {
            image.drawInRect(CGRectMake(0, 0, bounds.size.width, bounds.size.height), blendMode: .Normal, alpha: 0.25)
        }
    }
}

@IBDesignable class BackgroundImageTableView: UITableView {

    static let backgroundImage = UIImage(named: "Background")

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let image = BackgroundImageView.backgroundImage {
            image.drawInRect(CGRectMake(0, 0, bounds.size.width, bounds.size.height), blendMode: .Normal, alpha: 0.25)
        }
    }
}
