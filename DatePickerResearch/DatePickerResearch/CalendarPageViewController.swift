//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentViewController = createContentViewController() {
            contentViewController.month = NSDate()
            setViewControllers([contentViewController], direction: .Reverse, animated: false, completion: nil)
            dataSource = self
            delegate = self
        }
    }

    private func createContentViewController() -> MonthViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("MonthViewController") as! MonthViewController
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
            newMonthViewController.month = currentMonth.dateByAddingMonths(-1)
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
            newMonthViewController.month = currentMonth.dateByAddingMonths(1)
        }
        return newMonthViewController
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {

}
