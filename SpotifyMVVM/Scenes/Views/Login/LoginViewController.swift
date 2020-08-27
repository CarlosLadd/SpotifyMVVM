//
//  LoginViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/26/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class LoginViewController : BaseViewController {
    
    // Spotify Configuration
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Static.SpotifyClientID, redirectURL: Static.SpotifyRedirectURI)
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: Static.SpotifyBaseURLToken + "/v1/swap")
        configuration.tokenRefreshURL = URL(string: Static.SpotifyBaseURLToken + "/v1/refresh")
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
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    // Login Button
    private lazy var connectButton = SpotifyLoginButton(title:
        NSLocalizedString("loginButtonTitle", comment: "").uppercased())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        activeStatusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        
        // UI
        renderLoginButtonUI()
    }
    
    // MARK: - UI
    
    private func renderLoginButtonUI() {
        connectButton.frame = CGRect(x: 0, y: (view.bounds.height / 2) - (Static.margin44x / 2), width: 0, height: Static.margin44x)
        
        updateLoginButtonWith(title: connectButton.titleLabel?.text ?? "")
        connectButton.addTarget(self, action: #selector(didTapOnLoginButtonAction(_:)), for: .touchUpInside)
        
        // Render
        self.view.addSubview(connectButton)
    }
    
    // MARK: - Tap Actions
    
    @objc private func didTapOnLoginButtonAction(_ sender: UIButton) {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userTopRead]

        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        }
        else {
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    // MARK: - UI State Handler
    
    private func updateViewOnBasedState() {
        if (appRemote.isConnected) {
            let titleValue = "You are connected".uppercased()
            let title = NSAttributedString(string: titleValue, attributes: connectButton.titleAttributes)
            
            connectButton.setAttributedTitle(title, for: .normal)
            updateLoginButtonWith(title: titleValue)
        }
        else {
            let titleValue = "Waiting for connection".uppercased()
            let title = NSAttributedString(string: titleValue, attributes: connectButton.titleAttributes)
            
            connectButton.setAttributedTitle(title, for: .normal)
            updateLoginButtonWith(title: titleValue)
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateLoginButtonWith(title: String) {
        let connectButtonWidth = Static.widthForViewLabel(text: title, font: connectButton.titleLabel!.font, height: connectButton.bounds.height) + (Static.margin32x * 3)
        
        connectButton.frame.size.width = connectButtonWidth
        connectButton.frame.origin.x = (view.bounds.width / 2) - (connectButtonWidth / 2)
    }

    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
    
}

// MARK: - Session Manager Delegate

extension LoginViewController : SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Dismiss")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
}

// MARK: - Remote Delegate

extension LoginViewController : SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewOnBasedState()
        
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        
        // FIXME: Rendering Global Player
        // fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewOnBasedState()
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewOnBasedState()
        lastPlayerState = nil
    }
    
}

// MARK: - Remote Player State Delegate

extension LoginViewController : SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        // update(playerState: playerState)
    }
    
}
