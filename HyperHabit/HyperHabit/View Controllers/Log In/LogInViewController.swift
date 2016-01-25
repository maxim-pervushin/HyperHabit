//
// Created by Maxim Pervushin on 22/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class LogInViewController: ThemedViewController {

    // MARK: LogInViewController @IB

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerToBottomConstraint: NSLayoutConstraint!

    @IBAction func logInButtonAction(sender: AnyObject) {
        if let username = userNameTextField.text, password = passwordTextField.text {
            App.logInWithUsername(username, password: password, block: {
                success in
                print("Success: \(success)")
            })
        }
    }

    @IBAction func forgotPasswordButtonAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Reset Password", message: "Please enter the email address for your account.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            _ in
            if let textField = alertController.textFields?.first,
            let email = textField.text {
                App.resetPasswordWithUsername(email) {
                    success in
                    print("resetPasswordWithUsername: \(success)")
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addTextFieldWithConfigurationHandler(){
            textField in
            textField.placeholder = "Email"
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        if userNameTextField.isFirstResponder() {
            userNameTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }

    // MARK: LogInViewController

    private func setContainerBottomOffset(offset: CGFloat) {
        if !isViewLoaded() {
            return
        }
        view.layoutIfNeeded()
        containerToBottomConstraint?.constant = offset
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func keyboardWillShowNotification(notification: NSNotification) {
        guard
        let userInfo = notification.userInfo,
        let endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        setContainerBottomOffset(endFrameValue.CGRectValue().height)
    }

    private func keyboardWillHideNotification(notification: NSNotification) {
        setContainerBottomOffset(0)
    }

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: keyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: keyboardWillHideNotification)
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    private func commonInit() {
        subscribe()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }


    deinit {
        unsubscribe()
    }
}
