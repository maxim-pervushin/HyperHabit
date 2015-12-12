//
//  ThirdViewController.swift
//  PresentationResearch
//
//  Created by Maxim Pervushin on 10/12/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!

    var fromRect: CGRect?

    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func prepareForPresentation() {
        view.bringSubviewToFront(contentView)
        if let fromRect = fromRect {
            contentWidthConstraint.constant = fromRect.size.width
            contentHeightConstraint.constant = fromRect.size.height
            contentFromTopConstraint.constant = fromRect.origin.y
            contentLeadingConstraint.constant = fromRect.origin.x
        }
        view.layoutIfNeeded()
    }

    private func performPresentationWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        contentWidthConstraint.constant = 200
        contentHeightConstraint.constant = 200
        contentFromTopConstraint.constant = 0
        contentLeadingConstraint.constant = 0

        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .TransitionNone], animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }

    private func prepareForDismissal() {
        view.bringSubviewToFront(contentView)
        view.layoutIfNeeded()
    }

    private func performDismissalWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        print("performDismissalWithDuration")
        view.layoutIfNeeded()
        if let fromRect = fromRect {
            contentWidthConstraint.constant = fromRect.size.width
            contentHeightConstraint.constant = fromRect.size.height
            contentFromTopConstraint.constant = fromRect.origin.y
            contentLeadingConstraint.constant = fromRect.origin.x
        }
        UIView.animateWithDuration(duration / 2, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5,  options: [.CurveEaseInOut, .TransitionNone], animations: {
            // Layout content
            self.view.layoutIfNeeded()
        }, completion: completion)
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

extension ThirdViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ThirdViewController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 5
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

        // Present
        if let thirdViewController = toViewController as? ThirdViewController {
            thirdViewController.prepareForPresentation()
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            thirdViewController.performPresentationWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }

        // Dismiss
        if let thirdViewController = fromViewController as? ThirdViewController {
            thirdViewController.prepareForDismissal()
            thirdViewController.performDismissalWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

    func animationEnded(transitionCompleted: Bool) {
    }
}
