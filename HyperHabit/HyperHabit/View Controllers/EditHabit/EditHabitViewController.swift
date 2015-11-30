//
// Created by Maxim Pervushin on 24/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class EditHabitViewController: UIViewController {

    // MARK: EditHabitViewController @IB

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView?.layer.cornerRadius = 3
        }
    }

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    @IBAction func nameTextFieldEditingChanged(sender: AnyObject) {
        editor.name = nameTextField.text
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
        guard let habit = self.editor.updatedHabit else {
            return
        }
        if dataSource.saveHabit(habit) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: EditHabitViewController

    let editor = HabitEditor()
    let dataSource = EditHabitDataSource(dataManager: App.dataManager)

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.nameTextField.text = self.editor.name
            self.saveButton.enabled = self.editor.canSave
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editor.changesObserver = self
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil, usingBlock: keyboardWillShow)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField?.becomeFirstResponder()
        updateUI()
    }

    // MARK: Keyboard notifications

    private func keyboardWillShow(notification: NSNotification) {
        if let endRect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.CGRectValue() {
            bottomLayoutConstraint.constant = endRect.height + bottomLayoutConstraint.constant
            self.view.setNeedsLayout()
        }
    }
}

extension EditHabitViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}