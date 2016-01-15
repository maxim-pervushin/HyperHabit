//
// Created by Maxim Pervushin on 08/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    // MARK: DatePickerViewController @IB

    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var headerTopView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTopView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: MXCalendarView!

    @IBAction func todayButtonAction(sender: AnyObject) {
//        scrollToDate(NSDate(), animated: true)
        calendarView?.scrollToDate(NSDate(), animated: true)
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
        finished?(nil)
    }

    // MARK: DatePickerViewController

    var finished: ((NSDate?) -> ())?

    var selectedDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    var startDate = NSDate(timeIntervalSince1970: 0) {
        didSet {
            updateUI()
        }
    }

    var endDate = NSDate() {
        didSet {
            updateUI()
        }
    }

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        calendarView?.startDate = startDate
        calendarView?.endDate = endDate
        calendarView?.calendar = calendar
        calendarView?.selectedDate = selectedDate
    }

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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedDate = selectedDate {
            calendarView?.scrollToDate(selectedDate, animated: false)
        } else {
            calendarView?.scrollToDate(NSDate(), animated: false)
        }
    }
}

extension DatePickerViewController {

    // TODO: Would be great to move all this transition-related stuff somewhere. Somehow...

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

extension DatePickerViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension DatePickerViewController: UIViewControllerAnimatedTransitioning {

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

        if let pickDateViewController = toViewController as? DatePickerViewController {
            pickDateViewController.prepareForPresentation()
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            pickDateViewController.performPresentationWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }

        if let pickDateViewController = fromViewController as? DatePickerViewController {
            pickDateViewController.prepareForDismissal()
            pickDateViewController.performDismissalWithDuration(transitionDuration(transitionContext), completion: {
                _ in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

    func animationEnded(transitionCompleted: Bool) {
    }
}

//extension DatePickerViewController: UICollectionViewDataSource {
//
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 12 * (maxYear - minYear + 1) - minMonth - (12 - maxMonth) + 1
//    }
//
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let minMonth = minDate.firstDayOfMonth()
//        let currentMonth = minMonth.dateByAddingMonths(section)
//        return daysBeforeInMonth(currentMonth) + currentMonth.numberOfDaysInMonth() + daysAfterInMonth(currentMonth)
//    }
//
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! DayCell
//
//        let minMonth = minDate.firstDayOfMonth()
//        let currentMonth = minMonth.dateByAddingMonths(indexPath.section)
//        let daysBefore = daysBeforeInMonth(currentMonth)
//        let cellDate = currentMonth.firstDayOfMonth().dateByAddingDays(indexPath.row - daysBefore)
//        cell.date = cellDate
//
//        if indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth() {
//            cell.dayLabel.textColor = UIColor.clearColor()
//        } else if cellDate < minDate || cellDate > maxDate {
//            cell.dayLabel.textColor = App.themeManager.theme.inactiveTextColor
//        } else if cellDate.isSaturday() || cellDate.isSunday() {
//            cell.dayLabel.textColor = UIColor.blueColor()
//        } else {
//            cell.dayLabel.textColor = App.themeManager.theme.textColor
//        }
//
//        if let selectedDate = selectedDate where cellDate.dateByIgnoringTime() == selectedDate.dateByIgnoringTime()
//                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
//            cell.highlightColor = UIColor.greenColor()
//        } else if cellDate.dateByIgnoringTime() == NSDate().dateByIgnoringTime()
//                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
//            cell.highlightColor = UIColor.redColor()
//        } else {
//            cell.highlightColor = UIColor.clearColor()
//        }
//
//        return cell
//    }
//
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MonthCollectionReusableView.defaultHeaderReuseIdentifier, forIndexPath: indexPath) as! MonthCollectionReusableView
//            let firstDayOfMonth = minDate.dateByAddingMonths(indexPath.section)
//            header.month = firstDayOfMonth
//            return header
//        } else {
//            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: LineCollectionReusableView.defaultFooterReuseIdentifier, forIndexPath: indexPath)
//        }
//    }
//}
//
//extension DatePickerViewController: UICollectionViewDelegate {
//
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if let date = (collectionView.cellForItemAtIndexPath(indexPath) as! DayCell).date {
//            selectedDate = date
//            finished?(date)
//        }
//    }
//}
//
//extension DatePickerViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let side = CGFloat(collectionView.frame.size.width / 7)
//        return CGSizeMake(side, side)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width = collectionView.frame.size.width
//        let height = CGFloat(width / 7)
//        return CGSizeMake(width, height * 1.25)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        let width = collectionView.frame.size.width
//        let height = LineCollectionReusableView.defaultHeight
//        return CGSizeMake(width, height)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsZero
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//}
