//
// Created by Maxim Pervushin on 18/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol MXReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension MXReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(self)
    }
}
