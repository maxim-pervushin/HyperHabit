//
// Created by Maxim Pervushin on 22/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol CalendarPageViewControllerDelegate: class {

    func calendarPageViewController(controller: CalendarPageViewController, didPickDate date: NSDate)
}

class CalendarPageViewController: UIPageViewController {

    weak var calendarPageViewControllerDelegate: CalendarPageViewControllerDelegate?

    var minDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    var maxDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentViewController = createContentViewController() {
            contentViewController.month = NSDate()
            contentViewController.minDate = minDate
            contentViewController.maxDate = maxDate
            contentViewController.monthViewControllerDelegate = self
            setViewControllers([contentViewController], direction: .Reverse, animated: false, completion: nil)
            dataSource = self
            delegate = self
        }
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        guard let viewControllers = viewControllers else {
            return
        }

        for viewController in viewControllers {
            if let monthViewController = viewController as? MonthViewController {
                monthViewController.minDate = minDate
                monthViewController.maxDate = maxDate
            }
        }
    }

    private func createContentViewController() -> MonthViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier(MonthViewController.defaultStoryboardID) as! MonthViewController
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentMonthViewController = viewController as? MonthViewController else {
            return nil
        }
        guard let newMonthViewController = createContentViewController() else {
            return nil
        }

        if let currentMonth = currentMonthViewController.month {
            if let minDate = minDate where currentMonth < minDate {
                return nil
            }
            newMonthViewController.month = currentMonth.dateByAddingMonths(-1)
            newMonthViewController.minDate = minDate
            newMonthViewController.maxDate = maxDate
            newMonthViewController.monthViewControllerDelegate = self
        }
        return newMonthViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentMonthViewController = viewController as? MonthViewController else {
            return nil
        }
        guard let newMonthViewController = createContentViewController() else {
            return nil
        }

        if let currentMonth = currentMonthViewController.month {
            if let maxDate = maxDate where currentMonth > maxDate {
                return nil
            }
            newMonthViewController.month = currentMonth.dateByAddingMonths(1)
            newMonthViewController.minDate = minDate
            newMonthViewController.maxDate = maxDate
            newMonthViewController.monthViewControllerDelegate = self
        }
        return newMonthViewController
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {

}

extension CalendarPageViewController: MonthViewControllerDelegate {

    func monthViewController(controller: MonthViewController, didPickDate date: NSDate) {
        calendarPageViewControllerDelegate?.calendarPageViewController(self, didPickDate: date)
    }
}