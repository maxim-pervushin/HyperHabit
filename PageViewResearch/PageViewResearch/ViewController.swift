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

    private var startYear: Int {
        let date = NSDate(timeIntervalSince1970: 0)
        return NSCalendar.currentCalendar().component(.Year, fromDate: date)
    }

    private var endYear: Int {
        let date = NSDate()
        return NSCalendar.currentCalendar().component(.Year, fromDate: date)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: endYear - startYear - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
    }
}

extension ViewController: UICollectionViewDataSource {

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return endYear - startYear
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContentCell", forIndexPath: indexPath)
        if let label = cell.viewWithTag(11111) as? UILabel {
            label.text = "\(startYear + indexPath.row)"
        }
        return cell
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UICollectionViewDelegate {

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: endYear - startYear - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
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
