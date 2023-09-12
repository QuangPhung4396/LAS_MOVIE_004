//
//  AppDelegate.swift
//  Move004
//
//  Created by apple on 05/09/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var naviVC: UINavigationController?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupRootVC()
        return true
    }

    func setupRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let root: MainController = MainController()
        naviVC = UINavigationController(rootViewController: root)
        naviVC?.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }
}

