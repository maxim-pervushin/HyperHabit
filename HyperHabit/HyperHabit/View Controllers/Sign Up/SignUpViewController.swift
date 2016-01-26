//
// Created by Maxim Pervushin on 26/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class SignUpViewController: ThemedViewController {

    // MARK: SignUpViewController @IB

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerToBottomConstraint: NSLayoutConstraint!

    @IBAction func signUpButtonAction(sender: AnyObject) {
        if let username = userNameTextField.text, password = passwordTextField.text {
            App.signUpWithUsername(username, password: password, block: {
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

    @IBAction func cancelButtonAction(sender: AnyObject) {
        completionHandler?()
    }

    // MARK: SignUpViewController

    var completionHandler: (Void -> Void)?

    private func showError(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
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
