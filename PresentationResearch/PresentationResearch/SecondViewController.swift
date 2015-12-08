//
// Created by Maxim Pervushin on 08/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!

    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func prepareForPresentation() {
        view.bringSubviewToFront(headerView)
        headerTopConstraint.constant = -headerHeightConstraint.constant
        containerTopConstraint.constant = -headerHeightConstraint.constant - containerHeightConstraint.constant
        view.layoutIfNeeded()
    }

    private func performPresentationWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        print("performPresentationWithDuration")
        self.view.layoutIfNeeded()
        headerTopConstraint.constant = 0
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(duration / 2, animations: {
            // Layout header
            self.view.layoutIfNeeded()
        }, completion: {
            _ in
            self.containerTopConstraint.constant = self.headerHeightConstraint.constant
            self.view.setNeedsUpdateConstraints()

            UIView.animateWithDuration(duration / 2, animations: {
                // Layout content
                self.view.layoutIfNeeded()
            }, completion: completion)
        })
    }

    private func prepareForDismissal() {
        view.bringSubviewToFront(headerView)
        headerTopConstraint.constant = 0
        containerTopConstraint.constant = headerHeightConstraint.constant
        view.layoutIfNeeded()
    }

    private func performDismissalWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        print("performDismissalWithDuration")
        view.layoutIfNeeded()
        containerTopConstraint.constant = -headerHeightConstraint.constant - containerHeightConstraint.constant
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(duration / 2, animations: {
            // Layout content
            self.view.layoutIfNeeded()
        }, completion: {
            _ in
            self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
            self.view.setNeedsUpdateConstraints()

            UIView.animateWithDuration(duration / 2, animations: {
                // Layout header
                self.view.layoutIfNeeded()
            }, completion: completion)
        })
    }

    private func commonInit() {
        transitioningDelegate = self
        modalPresentationStyle = .Custom
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension SecondViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension SecondViewController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            print("Invalid fromViewController")
            return
        }
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            print("Invalid toViewController")
            return
        }
        guard let containerView = transitionContext.containerView() else {
            print("Invalid containerView")
            return
        }

        if let secondViewController = toViewController as? SecondViewController {
            secondViewController.prepareForPresentation()
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            secondViewController.performPresentationWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }

        if let secondViewController = fromViewController as? SecondViewController {
            secondViewController.prepareForDismissal()
            secondViewController.performDismissalWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

    func animationEnded(transitionCompleted: Bool) {
    }
}
