//
// Created by Maxim Pervushin on 04/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {

    @IBInspectable dynamic var cornerRadius: CGFloat {
        // UI_APPEARANCE_SELECTOR
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
