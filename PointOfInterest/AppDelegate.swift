//
//  AppDelegate.swift
//  PointOfInterest
//
//  Created by David Linhares on 28/11/2018.
//  Copyright © 2018 David Linhares. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = UINavigationController(rootViewController: MainViewController())
        w.makeKeyAndVisible()
        window = w

        return true
    }
}

