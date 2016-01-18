//
// Created by Maxim Pervushin on 18/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol Themed: class {

    func subscribeToThemeManagerNotifications()

    func unsubscribeFromThemeManagerNotifications()

    func updateTheme()

    func themedInit()

    func themedDeinit()
}

extension Themed where Self: UIViewController {

    func subscribeToThemeManagerNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(ThemeManager.changedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.setNeedsStatusBarAppearanceUpdate()
            self.updateTheme()
        })
        setNeedsStatusBarAppearanceUpdate()
        updateTheme()
    }

    func unsubscribeFromThemeManagerNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ThemeManager.changedNotification, object: nil)
    }

    func updateTheme() {

    }

    func themedInit() {
        modalPresentationCapturesStatusBarAppearance = true
        subscribeToThemeManagerNotifications()
    }

    func themedDeinit() {
        unsubscribeFromThemeManagerNotifications()
    }
}

class ThemedNavigationController: UINavigationController, Themed {

    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        themedInit()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        themedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        themedInit()
    }

    deinit {
        themedDeinit()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }
}

class ThemedViewController: UIViewController, Themed {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        themedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        themedInit()
    }

    deinit {
        themedDeinit()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }
}

class ThemedTableViewController: UITableViewController, Themed {

    func updateTheme() {
        if !isViewLoaded() {
            return
        }
        view.backgroundColor = App.themeManager.theme.backgroundColor
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        themedInit()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        themedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        themedInit()
    }

    deinit {
        themedDeinit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }
}

