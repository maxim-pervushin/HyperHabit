//
//  ViewController.swift
//  PageViewResearch
//
//  Created by Maxim Pervushin on 12/01/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            collectionView.reloadData()
        }
    }

    let startDate = NSDate().dateByAddingMonths(-4).dateByAddingDays(5)
    let endDate = NSDate()

    private var startYear: Int {
        return calendar.component(.Year, fromDate: startDate)
    }

    private var startMonth: Int {
        return calendar.component(.Month, fromDate: startDate)
    }

    private var endYear: Int {
        return calendar.component(.Year, fromDate: endDate)
    }

    private var endMonth: Int {
        return calendar.component(.Month, fromDate: endDate)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        print("startDate:\(startDate), endDate:\(endDate)");
        print("startYear:\(startYear), endYear:\(endYear)");
        print("startMonth:\(startMonth), endMonth:\(endMonth)");

        let lastSection = numberOfSectionsInCollectionView(collectionView) - 1
        let lastRow = collectionView(collectionView, numberOfItemsInSection: lastSection) - 1
        let indexPath = NSIndexPath(forRow: lastRow, inSection: lastSection)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)

//        view.layoutIfNeeded()
//        collectionViewHeightConstraint.constant = collectionView.frame.size.width
//        view.layoutIfNeeded()
    }
}

extension ViewController: UICollectionViewDataSource {

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return endYear - startYear + 1
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12 - startMonth + 1

        } else if section == numberOfSectionsInCollectionView(collectionView) - 1 {
            return endMonth

        } else {
            return 12
        }
    }

    private func month(indexPath: NSIndexPath) -> NSDate {
        var monthToAdd = indexPath.row
        if indexPath.section > 0 {
            for section in 0 ... indexPath.section - 1 {
                monthToAdd += collectionView(collectionView, numberOfItemsInSection: section)
            }
        }
        return startDate.firstDayOfMonth().dateByAddingMonths(monthToAdd)
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXMonthCell.defaultIdentifier, forIndexPath: indexPath) as! MXMonthCell
        cell.monthView?.calendar = calendar
        cell.monthView?.startDate = startDate
        cell.monthView?.endDate = endDate
        cell.monthView?.month = month(indexPath)
        cell.monthView?.dateSelectedHandler = dateSelectedHandler
        return cell
    }

    private func dateSelectedHandler(date: NSDate) {
        print("dateSelected: \(date)")
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
}
