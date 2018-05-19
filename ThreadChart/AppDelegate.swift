//
//  AppDelegate.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 27.11.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let splitController = window?.rootViewController as? UISplitViewController else { return true }
        splitController.delegate = self
        splitController.preferredDisplayMode = .allVisible

        return true
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}

