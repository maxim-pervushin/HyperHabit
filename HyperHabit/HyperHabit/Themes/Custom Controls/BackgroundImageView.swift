//
// Created by Maxim Pervushin on 19/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundImageView: UIView {

    static let backgroundImage = UIImage(named: "FoggyForest")

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let image = BackgroundImageView.backgroundImage {
            image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height), blendMode: .Normal, alpha: 0.25)
        }
    }
}

@IBDesignable class BackgroundImageTableView: UITableView {

    static let backgroundImage = UIImage(named: "FoggyForest")

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let image = BackgroundImageView.backgroundImage {
            image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height), blendMode: .Normal, alpha: 0.25)
        }
    }
}
