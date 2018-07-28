//
//  AppDelegate.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hasData =  UserDefaults.standard.bool(forKey: UserDefaultsConstants.hasDataKey)
        let viewControllerId = hasData ? "GroupListViewController" : "AddGroupViewController"
        
        window?.rootViewController = hasData ?
            UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: viewControllerId)) :
            storyboard.instantiateViewController(withIdentifier: viewControllerId)
        window?.makeKeyAndVisible()
        return true
    }
}
