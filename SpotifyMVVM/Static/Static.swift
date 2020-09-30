//
//  Static.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import Foundation
import UIKit

open class Static: NSObject {
    
    // Singleton
    static let shared = Static()
    
    // Global Margins
    static let margin5x: CGFloat = 5.0
    static let margin10x: CGFloat = 10.0
    static let margin16x: CGFloat = 16.0
    static let margin20x: CGFloat = 20.0
    static let margin24x: CGFloat = 24.0
    static let margin32x: CGFloat = 32.0
    static let margin44x: CGFloat = 44.0
    static let margin64x: CGFloat = 64.0
    static let margin80x: CGFloat = 80.0
    static let margin112x: CGFloat = 112.0
    
    // Spotify Auth
    static let SpotifyBaseURLToken = "https://api.fuzzlyrobotics.com/"
    static let SpotifyClientID = "ab7c389908b14653b77a47ca8c82cad6"
    static let SpotifyRedirectURI = URL(string: "spotify-login-sdk-test-app://spotify-login-callback")!
    
    // Spotify Configuration
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Static.SpotifyClientID, redirectURL: Static.SpotifyRedirectURI)
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: Static.SpotifyBaseURLToken + "v1/swap")
        configuration.tokenRefreshURL = URL(string: Static.SpotifyBaseURLToken + "v1/refresh")
        return configuration
    }()
    
    // Session Manager
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    // App Remote
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    // Player State
    var lastPlayerState: SPTAppRemotePlayerState?
    
    // Spotify View State Delegate
    weak var spotifyViewStateDelegate: SpotifyViewStateDelegate?
    
    // Spotify API Token
    var spotifyAPIToken = ""
    
    // MARK: - Life Cycle
    
    private override init() {
        // Code
    }
    
    // MARK: - Dynamic Width ~ Height
    
    static func widthForViewLabel(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.width
    }
    
    static func heightForViewLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    // MARK: - Safe Area Margins
    
    static func hasTopNotch() -> CGFloat {
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                
                if let sdt: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    return sdt.window?.safeAreaInsets.top ?? 0.0
                }
            } else {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
            }
        }
        
        return 20.0
    }
    
    static func hasBottomArea() -> CGFloat {
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                
                if let sdt: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    return sdt.window?.safeAreaInsets.bottom ?? 0.0
                }
            } else {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
            }
        }
        
        return 0.0
    }
    
}

// MARK: - Session Manager Delegate

extension Static: SPTSessionManagerDelegate {
    
    public func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.spotifyViewStateDelegate?.spotifySessionManager(manager: manager, didInitiate: session)
        
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    public func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        self.spotifyViewStateDelegate?.spotifySessionManager(manager: manager, didRenew: session)
    }
    
    public func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        self.spotifyViewStateDelegate?.spotifySessionManager(manager: manager, didFailWith: error)
    }

}

// MARK: - App Remote Delegate

extension Static: SPTAppRemoteDelegate {
    
    public func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewOnBasedState()
        
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (_, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        
        self.appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.spotifyViewStateDelegate?.update(playerState: playerState)
            }
        })
    }

    public func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewOnBasedState()
        lastPlayerState = nil
    }

    public func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewOnBasedState()
        lastPlayerState = nil
    }
    
    private func updateViewOnBasedState() {
        if appRemote.isConnected {
            self.spotifyViewStateDelegate?.spotifyAppRemoteDidConnected()
            
        } else {
            self.spotifyViewStateDelegate?.spotifyAppRemoteDidOffline()
        }
    }
    
}

// MARK: - Remote Player State Delegate

extension Static: SPTAppRemotePlayerStateDelegate {
    
    public func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.spotifyViewStateDelegate?.update(playerState: playerState)
    }
    
}
