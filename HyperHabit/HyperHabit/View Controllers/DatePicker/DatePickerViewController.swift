//
// Created by Maxim Pervushin on 02/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    // MARK: DatePickerViewController @IB

    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBAction func pickButtonAction(sender: AnyObject) {
        datePickerController?.didPickDate(datePicker.date)
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        datePickerController?.didCancel()
    }

    // MARK: DatePickerViewController

    var datePickerController: DatePickerController? {
        if let datePickerController = navigationController as? DatePickerController {
            return datePickerController
        }
        return nil
    }

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let maximumDate = datePickerController?.maximumDate {
            datePicker.maximumDate = maximumDate
        }
        if let date = datePickerController?.date {
            datePicker.date = date
        }
    }
}

extension DatePickerController {

    private func didPickDate(date: NSDate) {
        datePickerDelegate?.datePickerController(self, didPickDate: date)
    }

    private func didCancel() {
        datePickerDelegate?.datePickerControllerDidCancel(self)
    }
}