//
//  AppDelegate.swift
//  THackMarch2016
//
//  Created by Alex Zimin on 05/03/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    DataModelController.sharedInstance.setup()
    IQKeyboardManager.sharedManager().enable = true
    
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), forBarMetrics: .Default)
    
    Parse.setApplicationId("NsKIGE3Ff986ZBD4Uu2243PIyFzK08lY3fu9BGDx", clientKey: "TtQfUhtxPBiHYVl7piVn3JZWdfXVMbyq4MHu3T52")
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.makeKeyAndVisible()
    
    presentNesessaryWindow()
    
//    FBSDKGraphRequest(graphPath: "/\(json["id"].stringValue)/picture", parameters: ["height": 100]).startWithCompletionHandler({ (connection, result, error) -> Void in
//      print(result)
//    })
    
    return true
  }
  
  func presentNesessaryWindow() {
    ClientModel.sharedInstance.fetchData()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if FBSDKAccessToken.currentAccessToken() != nil {
      window?.rootViewController = storyboard.instantiateInitialViewController()
    } else {
      window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
    }
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
    FBSDKAppEvents.activateApp()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    let fbFalg = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    return fbFalg
  }
}

