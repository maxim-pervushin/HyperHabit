//
// Created by Maxim Pervushin on 24/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class EditHabitViewController: UIViewController {

    // MARK: EditHabitViewController @IB

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var repeatsTotalLabel: UILabel!
    @IBOutlet weak var repeatsTotalStepper: UIStepper!

    @IBAction func nameTextFieldEditingChanged(sender: AnyObject) {
        editor.name = nameTextField.text
    }

    @IBAction func repeatsTotalStepperValueChanged(sender: AnyObject) {
        editor.repeatsTotal = Int(repeatsTotalStepper.value)
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
        guard let habit = self.editor.updatedHabit else {
            return
        }
        if dataSource.saveHabit(habit) {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    // MARK: EditHabitViewController

    let editor = HabitEditor()
    let dataSource = EditHabitDataSource(dataManager: App.dataManager)

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.nameTextField.text = self.editor.name
            if let repeatsTotal = self.editor.repeatsTotal {
                self.repeatsTotalLabel.text = "\(repeatsTotal)"
            } else {
                self.repeatsTotalLabel.text = ""
            }
            self.saveButton.enabled = self.editor.canSave
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editor.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}

extension EditHabitViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}