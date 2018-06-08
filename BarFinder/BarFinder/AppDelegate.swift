//
//  AppDelegate.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = TabBarController()
        
        self.window!.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
