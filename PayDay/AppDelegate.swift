//
//  AppDelegate.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/15/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //UITabBar.appearance().tintColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        DropDown.startListeningToKeyboard()
        
        if let barFont = UIFont(name: "HelveticaNeue-Bold", size: 22.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:0.02, green:0.65, blue:0.88, alpha:1.0), NSFontAttributeName:barFont]
        }
//        //Изменяем цвет элементов статус бара
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
        
        
        
        ///////////////////////////
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = bounds.size.height
        
        var mainView: UIStoryboard!
        
        
        if screenHeight <= 568  {
            // Load Storyboard with name: iPhone4
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Storyboard2", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("iPhone35") as UIViewController
            self.window!.rootViewController = viewcontroller
            
        } else if screenHeight > 568 {
            mainView = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("iPhone6") as UIViewController
            self.window!.rootViewController = viewcontroller
        }
        
        ///////////////////////////////
        
        
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

