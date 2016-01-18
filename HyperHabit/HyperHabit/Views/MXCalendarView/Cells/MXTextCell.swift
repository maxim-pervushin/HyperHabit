//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXTextCell: UICollectionViewCell, MXReusableView {

    @IBOutlet weak var textLabel: UILabel!

    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
}
