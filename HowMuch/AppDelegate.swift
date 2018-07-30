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
    private let groupListId = "GroupListViewController"
    private let addGroupId = "AddGroupViewController"
    
    private var hasData: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsConstants.hasDataKey)
    }
    
    private var groups: [Group] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsConstants.groupKey),
            let groups = try? JSONDecoder().decode([Group].self, from: data) else { return [] }
        return groups
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootViewController: UIViewController
        if hasData {
            guard let vc = storyboard.instantiateViewController(withIdentifier: groupListId) as? GroupListViewController else { return false }
            vc.dataService = DataService(groups: groups)
            let navigationViewController = UINavigationController(rootViewController: vc)
            rootViewController = navigationViewController
        } else {
            guard let vc = storyboard.instantiateViewController(withIdentifier: addGroupId) as? AddGroupViewController else { return false }
            vc.dataService = DataService(groups: groups)
            rootViewController = vc
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}
