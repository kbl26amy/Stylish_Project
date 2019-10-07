//
//  AppDelegate.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/10.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
            IQKeyboardManager.shared.enable = true
            ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
            TPDSetup.setWithAppId(12348,
                                  withAppKey: "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF",
                                  with: TPDServerType.sandBox)
            TPDSetup.shareInstance().setupIDFA(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            TPDSetup.shareInstance().serverSync()
            return true }
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let appId: String = "1276368842536113"
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
