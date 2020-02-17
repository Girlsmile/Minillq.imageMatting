//
//  AppDelegate.swift
//  Minillq.imageMatting
//
//  Created by 古智鹏 on 2020/2/17.
//  Copyright © 2020 古智鹏. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.rootViewController = ViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

