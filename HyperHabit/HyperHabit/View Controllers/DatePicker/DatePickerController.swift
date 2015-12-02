//
// Created by Maxim Pervushin on 02/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {

    func datePickerController(controller: DatePickerController, didPickDate date: NSDate)

    func datePickerControllerDidCancel(controller: DatePickerController)
}

class DatePickerController: UINavigationController {

    weak var datePickerDelegate: DatePickerDelegate?

    var date: NSDate?
    var maximumDate: NSDate?
}
