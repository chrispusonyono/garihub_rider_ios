//
//  AppDelegate.swift
//  GariHub
//
//  Created by Kevin Lagat on 18/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let campaign = CampaignController()
        window?.rootViewController = campaign
        window?.makeKeyAndVisible()
        return true
    }


}

