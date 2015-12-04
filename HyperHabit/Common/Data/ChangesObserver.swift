//
// Created by Maxim Pervushin on 24/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

protocol ChangesObserver {

    func observableChanged(observable: AnyObject)
}
