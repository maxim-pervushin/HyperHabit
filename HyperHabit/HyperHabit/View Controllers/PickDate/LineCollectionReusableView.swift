//
// Created by Maxim Pervushin on 25/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class LineCollectionReusableView: UICollectionReusableView {

    static let defaultHeaderReuseIdentifier = "LineCollectionReusableViewHeader"
    static let defaultFooterReuseIdentifier = "LineCollectionReusableViewFooter"
    static var defaultHeight: CGFloat {
        return 1.0 / UIScreen.mainScreen().scale
    }
}

