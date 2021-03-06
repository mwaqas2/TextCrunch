//
//  AppDelegate.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-01-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register Parse Subclasses before initializing
        //ParseCrashReporting.enable(); //This was causing issues with the UserControllerTests crashing, investigate when we have time.
        User.registerSubclass()
        Listing.registerSubclass()
        Book.registerSubclass()
        Parse.setApplicationId("bd9pkI4jclGiICv1xM5YQiDfsxUD4SB4c3jQvBHW", clientKey: "nyPjmHMJAacFQVQSg7CTxZj3DWp1pKW9RBVsOPGK")
        PFFacebookUtils.initializeFacebook()
        PFTwitterUtils.initializeWithConsumerKey("9f2K1GV53otgmz9gaJIVLwYUm", consumerSecret: "mWWg7MVFQpsNhmgDAvLBfbFSCFmYwunkZi0FekvFCz8gxgpzeM")
        
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentSandbox: "AT_zVdLhRy_IwuNqTMBFPVImboNVwfR6CJXhIp62uSMHcsZhKD3X6y9d-Snn3i679gA8M8yP5Qk32ZEa"])
        
        var types: UIUserNotificationType =
            UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
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
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, withSession:PFFacebookUtils.session()) }
}

