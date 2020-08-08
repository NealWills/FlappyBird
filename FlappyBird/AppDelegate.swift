//
//  AppDelegate.swift
//  FlappyBird
//
//  Created by admin on 2020/8/8.
//  Copyright © 2020 NealCoder. All rights reserved.
//

import UIKit
import Log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        Log.open = .Open
        
        return true
    }


}

