//
//  AppDelegate.swift
//  Todoey
//
//  Created by Felipe on 19/3/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do{
            let _ = try Realm()
        }catch{
            print("Error initialising realm, \(error)")
        }
        
        return true
    }

}

