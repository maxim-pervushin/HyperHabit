//
// Created by Maxim Pervushin on 12/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXMPageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    private var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!

    private func commonInit() {
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("rightSwipeGestureRecognizerAction"))
        rightSwipeGestureRecognizer.numberOfTouchesRequired = 1
        rightSwipeGestureRecognizer.direction = .Right
        self.addGestureRecognizer(rightSwipeGestureRecognizer)
//        rightSwipeGestureRecognizer.delegate = self

        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("leftSwipeGestureRecognizerAction"))
        leftSwipeGestureRecognizer.numberOfTouchesRequired = 1
        leftSwipeGestureRecognizer.direction = .Left
        self.addGestureRecognizer(leftSwipeGestureRecognizer)
//        leftSwipeGestureRecognizer.delegate = self
    }

    @objc func rightSwipeGestureRecognizerAction() {
        print("rightSwipeGestureRecognizerAction")
    }

    @objc func leftSwipeGestureRecognizerAction() {
        print("leftSwipeGestureRecognizerAction")
    }
}
