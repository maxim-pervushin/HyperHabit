//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class HHCalendarPageViewController: UIPageViewController {

    var minDate: NSDate?
    var maxDate: NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentViewController = createContentViewController() {
            contentViewController.month = NSDate()
            setViewControllers([contentViewController], direction: .Reverse, animated: false, completion: nil)
            dataSource = self
            delegate = self
        }
    }

    private func createContentViewController() -> HHMonthViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("MonthViewController") as! HHMonthViewController
    }
}

extension HHCalendarPageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentMonthViewController = viewController as? HHMonthViewController else {
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
        }
        return newMonthViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentMonthViewController = viewController as? HHMonthViewController else {
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
        }
        return newMonthViewController
    }
}

extension HHCalendarPageViewController: UIPageViewControllerDelegate {

}
