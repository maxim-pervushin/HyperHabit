//
// Created by Maxim Pervushin on 04/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class RoundedVisualEffectView: UIVisualEffectView {

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

@IBDesignable class RoundedButton: UIButton {

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
