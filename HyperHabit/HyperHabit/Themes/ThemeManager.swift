//
// Created by Maxim Pervushin on 15/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ThemeManager {

    // MARK: ThemeManager public

    static let changedNotification = "ThemeManagerChangedNotification"

    var themes: [Theme] {
        return [
                defaultTheme,
                Theme(identifier: "sepia",
                        name: "Sepia",
                        dark: false,
                        backgroundColor: UIColor(red: 0.98, green: 0.96, blue: 0.91, alpha: 1),
                        foregroundColor: UIColor(red: 0.38, green: 0.24, blue: 0.13, alpha: 1)
                ),
                Theme(identifier: "gray",
                        name: "Gray",
                        dark: true,
                        backgroundColor: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1),
                        foregroundColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                ),
                Theme(identifier: "dark",
                        name: "Dark",
                        dark: true,
                        backgroundColor: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1),
                        foregroundColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                ),
        ]
    }

    let defaultTheme = Theme(identifier: "light",
            name: "Light",
            dark: false,
            backgroundColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1),
            foregroundColor: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
    )

    var theme: Theme {
        didSet {
            update()
        }
    }

    private func update() {

        UIView.appearance().tintColor = theme.foregroundColor

        // Navigation bars
        let titleTextAttributes = [
                NSForegroundColorAttributeName: theme.foregroundColor,
//                NSFontAttributeName: theme.fontOfSize(25)
        ]
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(theme.barBackgroundImage, forBarPosition: .Any, barMetrics: .Default)
//        UINavigationBar.appearance().tintColor = theme.backgroundColor
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
//        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(2, forBarMetrics: .Default)

        // Tab bars
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().barTintColor = theme.backgroundColor

//        UITabBarItem.appearance().


        // Table views
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UITableView.appearance().separatorColor = theme.foregroundColor.colorWithAlphaComponent(0.33)

        // Table view cells
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor

        // Table view header footer views
        UIView.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).backgroundColor = theme.backgroundColor
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).textColor = theme.foregroundColor

        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewCell.self]).textColor = theme.foregroundColor

        UIButton.appearance().backgroundColor = UIColor.clearColor()
        UIButton.appearance().setTitleColor(theme.textColor, forState: .Normal)
        UIButton.appearance().setTitleColor(theme.inactiveTextColor, forState: .Disabled)

        // BackgroundView
        BackgroundView.appearance().backgroundColor = theme.backgroundColor
        UILabel.appearanceWhenContainedInInstancesOfClasses([BackgroundView.self]).textColor = theme.foregroundColor

        // TintView
        TintView.appearance().backgroundColor = theme.foregroundColor.colorWithAlphaComponent(0.5)

        // LineView
        LineView.appearance().backgroundColor = theme.foregroundColor.colorWithAlphaComponent(0.25)
        LineCollectionReusableView.appearance().backgroundColor = UIColor.clearColor()

        // CVCalendar
        CVAuxiliaryView.appearance().backgroundColor = UIColor.clearColor()

        CVCalendarMenuView.appearance().backgroundColor = UIColor.clearColor()
        UILabel.appearanceWhenContainedInInstancesOfClasses([CVCalendarMenuView.self]).textColor = theme.foregroundColor

        CVCalendarView.appearance().backgroundColor = UIColor.clearColor()
        CVCalendarDayView.appearance().backgroundColor = UIColor.clearColor()

        UILabel.appearanceWhenContainedInInstancesOfClasses([CVCalendarDayView.self]).textColor = theme.foregroundColor


        // Hack to apply new appearance immediately
        for window in UIApplication.sharedApplication().windows {
            for subview in window.subviews {
                subview.removeFromSuperview()
                window.addSubview(subview)
            }
        }

        NSNotificationCenter.defaultCenter().postNotificationName(ThemeManager.changedNotification, object: self, userInfo: nil)

        saveDefaults()
    }

    private func saveDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(theme.identifier, forKey: "themeIdentifier")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    private func loadDefaults() {
        if let themeIdentifier = NSUserDefaults.standardUserDefaults().stringForKey("themeIdentifier") {
            var currentTheme = defaultTheme
            for theme in themes {
                if theme.identifier == themeIdentifier {
                    currentTheme = theme
                    break
                }
            }
            theme = currentTheme

        } else {
            theme = defaultTheme
        }
    }

    init() {
        self.theme = defaultTheme
        self.loadDefaults()
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timeout:", userInfo: nil, repeats: true)
//        self.timer.fire()
    }

    @objc private func timeout(sender: AnyObject?) {
        nextTheme()
    }

    private var currentThemeIndex = 0
    private var timer: NSTimer!

    func nextTheme() {
        currentThemeIndex++
        if currentThemeIndex >= themes.count {
            currentThemeIndex = 0
        }

        theme = themes[currentThemeIndex]
    }
}
