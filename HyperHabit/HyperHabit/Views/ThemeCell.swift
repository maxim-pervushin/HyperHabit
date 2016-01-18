//
// Created by Maxim Pervushin on 16/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell, MXReusableView {

    var theme: Theme? {
        didSet {
            textLabel?.text = theme?.name
        }
    }
}
