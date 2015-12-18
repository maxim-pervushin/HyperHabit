//
// Created by Maxim Pervushin on 16/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

// TODO: Fix invalid presentation animation

class PickThemeViewController: UIViewController {

    // MARK: PickThemeViewController @IB

    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var headerTopView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTopView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: PickThemeViewController

    private let dataSource = PickThemeDataSource()

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(ThemeManager.changedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ThemeManager.changedNotification, object: nil)
    }

    private func commonInit() {
        transitioningDelegate = self
        modalPresentationStyle = .Custom
        modalPresentationCapturesStatusBarAppearance = true
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }
}

extension PickThemeViewController {
    private func prepareForPresentation() {
        view.bringSubviewToFront(tintView)
        view.bringSubviewToFront(headerTopView)
        view.bringSubviewToFront(contentTopView)
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(contentView)
        headerTopConstraint.constant = -headerHeightConstraint.constant * 2
        containerTopConstraint.constant = (-headerHeightConstraint.constant - containerHeightConstraint.constant) * 2
        view.layoutIfNeeded()
    }

    private func performPresentationWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        view.layoutIfNeeded()
        headerTopConstraint.constant = 0
        view.setNeedsUpdateConstraints()
        tintView.alpha = 0

        UIView.animateWithDuration(duration / 2, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .TransitionNone], animations: {
            // Layout header
            self.view.layoutIfNeeded()
            self.tintView.alpha = 1

        }, completion: {
            _ in
            self.containerTopConstraint.constant = self.headerHeightConstraint.constant
            self.view.setNeedsUpdateConstraints()

            UIView.animateWithDuration(duration / 2, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .TransitionNone], animations: {
                // Layout content
                self.view.layoutIfNeeded()
            }, completion: completion)
        })
    }

    private func prepareForDismissal() {
        view.bringSubviewToFront(tintView)
        view.bringSubviewToFront(headerTopView)
        view.bringSubviewToFront(contentTopView)
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(contentView)
        headerTopConstraint.constant = 0
        containerTopConstraint.constant = headerHeightConstraint.constant
        view.layoutIfNeeded()
    }

    private func performDismissalWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        view.layoutIfNeeded()
        containerTopConstraint.constant = (-headerHeightConstraint.constant - containerHeightConstraint.constant) * 2
        view.setNeedsUpdateConstraints()
        tintView.alpha = 1

        UIView.animateWithDuration(duration / 2, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .TransitionNone], animations: {
            // Layout content
            self.view.layoutIfNeeded()

        }, completion: {
            _ in
            self.headerTopConstraint.constant = -self.headerHeightConstraint.constant * 2
            self.view.setNeedsUpdateConstraints()

            UIView.animateWithDuration(duration / 2, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.CurveEaseInOut, .TransitionNone], animations: {
                // Layout header
                self.view.layoutIfNeeded()
                self.tintView.alpha = 0

            }, completion: completion)
        })
    }
}

extension PickThemeViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfThemes
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ThemeCell.defaultReuseIdentifier, forIndexPath: indexPath) as! ThemeCell
        let theme = dataSource.themeAtIndex(indexPath.row)
        cell.theme = theme
        if theme == dataSource.currentTheme {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
}

extension PickThemeViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataSource.currentTheme = dataSource.themeAtIndex(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }
}

extension PickThemeViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension PickThemeViewController: UIViewControllerAnimatedTransitioning {

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

        if let pickThemeViewController = toViewController as? PickThemeViewController {
            pickThemeViewController.prepareForPresentation()
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            pickThemeViewController.performPresentationWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }

        if let pickThemeViewController = fromViewController as? PickThemeViewController {
            pickThemeViewController.prepareForDismissal()
            pickThemeViewController.performDismissalWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

    func animationEnded(transitionCompleted: Bool) {
    }
}
