//
//  AppDelegate.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var loginViewController = LoginViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = DIContainer.shared
        
        if #available(iOS 13.0, *) {
            // Use UISceneDelegate
        } else {
            let storyboard = UIStoryboard(name: "Base", bundle: nil)
            let navigationController: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            navigationController.viewControllers = [LoginBuilder.buildViewController()]
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // MARK: - URL Handler
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Static.shared.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    // MARK: - States
    
    func applicationWillResignActive(_ application: UIApplication) {
        if Static.shared.appRemote.isConnected {
            Static.shared.appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if Static.shared.appRemote.connectionParameters.accessToken != nil {
            Static.shared.appRemote.connect()
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }

}
