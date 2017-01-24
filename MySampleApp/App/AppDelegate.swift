//
//  AppDelegate.swift
//  Swap
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.8
//
import UIKit
import IQKeyboardManagerSwift
import SwifteriOS
import AWSCognitoIdentityProvider
import OneSignal
import Branch
import Fabric
import Answers
import TwitterKit
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UIScrollViewDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self(), Twitter.self(), Answers.self()])
        Fabric.sharedSDK().debug = true
        let branch = Branch.getInstance()
        
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (param, error) in
            
        })
        
        // Override point for customization after application launch.
        AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
        
        // One Signal Push Notification
        OneSignal.initWithLaunchOptions(launchOptions, appId: ONE_SIGNAL_APP_ID, handleNotificationAction: { (result) in
            // Completion Block Called when the user presses an action button from a Swap Request
            let payload = result?.notification.payload
            // Obtain the Action Selected From Notification
            
            if let additionalData = payload?.additionalData, let actionSelected = additionalData["actionSelected"] as? String {
                
                let username = additionalData["username"] as? String ?? ""
                
                switch actionSelected{
                case "Accept":
                    // User Accepted
                    SwapUser(username: getUsernameOfSignedInUser()).performActionOnSwapRequestFromUser(withUsername: username, doAccept: true)
                    break
                    
                case "Decline":
                    SwapUser(username: getUsernameOfSignedInUser()).performActionOnSwapRequestFromUser(withUsername: username, doAccept: true)
                    break
                    
                default: break
                }
                
            }
            
            
        })
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // this assumes your storyboard is titled "Main.storyboard"
        
        // Reference to Profile View Controller
        let profileViewControllerID: String = "ProfileViewController"
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: profileViewControllerID)
        
        // Reference to Sign In View Controller
        let signInVCID: String = "SignInViewController"
        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: signInVCID)
        
        // if signed in  -> profile view controller else -> login view controller
        var defaultVC: UIViewController = isSignedIn() ? profileVC : signInVC
        
        
        
        
        
        // If there is no saved view controller ID in UserDefaults, it instantiates the default view controller as the initial view controller. However, if there is, it instantiates the last view controller it can remember being on
        self.window?.rootViewController =  (getLastViewControllerID() != nil ) ? mainStoryboard.instantiateViewController(withIdentifier: getLastViewControllerID()! ) : defaultVC
        self.window?.makeKeyAndVisible()
        
        
        //enable keyboard manager
        IQKeyboardManager.sharedManager().enable = true
        
        //make UI changes
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        return true
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // print("application application: \(application.description), openURL: \(url.absoluteURL), sourceApplication: \(sourceApplication)")
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation as AnyObject)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // Clear the badge icon when you open the app.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AWSMobileClient.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AWSMobileClient.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error as NSError)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        AWSMobileClient.sharedInstance.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if Twitter.sharedInstance().application(app, open:url, options: options) {
            return true
            
        }
        
        Swifter.handleOpenURL(url)
        youtube_oauth2.handleRedirectURL(url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        Branch.getInstance().continue(userActivity)
        
        return true
    }
    
    
}
