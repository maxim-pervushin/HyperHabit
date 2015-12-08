//
// Created by Maxim Pervushin on 08/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol PickDateViewControllerDelegate: class {

    func pickDateViewController(controller: PickDateViewController, didPickDate date: NSDate)

    func pickDateViewControllerDidCancel(controller: PickDateViewController)
}

class PickDateViewController: UIViewController {

    // MARK: DatePickerViewController @IB

    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBAction func pickButtonAction(sender: AnyObject) {
        datePickerDelegate?.pickDateViewController(self, didPickDate: datePicker.date)
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        datePickerDelegate?.pickDateViewControllerDidCancel(self)
    }

    // MARK: DatePickerViewController

    weak var datePickerDelegate: PickDateViewControllerDelegate?
    var date: NSDate? {
        didSet {
            updateUI()
        }
    }
    var maximumDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        if let date = date {
            datePicker.date = date
        } else  {
            datePicker.date = NSDate()
        }

        if let maximumDate = maximumDate {
            datePicker.maximumDate = maximumDate
        } else {
            datePicker.maximumDate = nil
        }
    }
}
