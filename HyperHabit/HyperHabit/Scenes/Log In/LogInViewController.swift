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
                success, error in

                if let error = error {
                    self.showError(error)
                }

                if success {
                    self.completionHandler?()
                }
            })
        }
    }

    @IBAction func signUpButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("ShowSignUp", sender: self)
    }

    @IBAction func forgotPasswordButtonAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Reset Password", message: "Please enter the email address for your account.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            _ in

            if let textField = alertController.textFields?.first,
            let email = textField.text {
                App.resetPasswordWithUsername(email) {
                    success, error in
                    if let error = error {
                        self.showError(error)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        alertController.addTextFieldWithConfigurationHandler(){
            textField in

            textField.placeholder = "Email"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        if userNameTextField.isFirstResponder() {
            userNameTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
        completionHandler?()
    }

    // MARK: LogInViewController

    var completionHandler: (Void -> Void)?

    private func showError(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

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
        setContainerBottomOffset(endFrameValue.CGRectValue().height - 80)
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let signUpViewController = segue.destinationViewController as? SignUpViewController {
            signUpViewController.completionHandler = {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }

}
