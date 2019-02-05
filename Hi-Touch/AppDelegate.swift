//
//  AppDelegate.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/02.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
//import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        do{
//            _ = try Realm()
//        }catch{
//            print("Error: \(error)")
//        }
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true

        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {

    }


}

