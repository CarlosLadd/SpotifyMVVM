//
//  SceneDelegate.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    lazy var loginViewController = LoginViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            print("BaseNavigationController not found")
            return
        }
        
        navigationController.viewControllers = [LoginBuilder.buildViewController()]
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        let parameters = Static.shared.appRemote.authorizationParameters(from: url)

        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            Static.shared.appRemote.connectionParameters.accessToken = accessToken
            
        } else if parameters?[SPTAppRemoteErrorDescriptionKey] != nil {
            // Show the error
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if Static.shared.appRemote.connectionParameters.accessToken != nil {
            Static.shared.appRemote.connect()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if Static.shared.appRemote.isConnected {
            Static.shared.appRemote.disconnect()
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }

}
