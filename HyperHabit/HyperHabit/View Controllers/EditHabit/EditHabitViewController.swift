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

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: nil, usingBlock: keyboardWillChangeFrame)
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editor.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField?.becomeFirstResponder()
        subscribe()
        updateUI()
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField?.resignFirstResponder()
        unsubscribe()
    }

    // MARK: Keyboard notifications

    private func keyboardWillChangeFrame(notification: NSNotification) {
        guard
        let userInfo = notification.userInfo,
        endRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(),
        duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }

        bottomLayoutConstraint.constant = endRect.height + 20
        UIView.animateWithDuration(duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension EditHabitViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}