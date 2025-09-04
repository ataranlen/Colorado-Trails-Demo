//
//  AppDelegate.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/4/25.
//

import UIKit
import OAuthSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        if options[.sourceApplication] as? String == "com.apple.SafariViewService" {
            OAuthSwift.handle(url: url)
        }
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }
}
