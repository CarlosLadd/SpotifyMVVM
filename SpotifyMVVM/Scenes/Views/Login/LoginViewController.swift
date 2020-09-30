//
//  LoginViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/26/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    // Login Button
    private lazy var connectButton = SpotifyLoginButton(title:
        NSLocalizedString("loginButtonTitle", comment: "").uppercased())
    
    // View Model
    
    var viewModel: LoginViewModelProtocol?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        activeStatusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        
        // UI
        renderLoginButtonUI()
        setupBindables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // SP View State
        Static.shared.spotifyViewStateDelegate = self
        
        // Only for test
        Static.shared.sessionManager.alwaysShowAuthorizationDialog = true
    }
    
    // MARK: - Reactive Behaviour
    
    private func setupBindables() {
        viewModel?.startInitialConfiguration()
        
        viewModel?.didMessageSuccess = { [weak self] message in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.didMessageSuccess(message: message)
            }
        }
        
        viewModel?.didMessageError = { [weak self] error in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.didMessageError(error: error)
            }
        }
    }
    
    // MARK: - ViewModel  Delegate
    
    private func didMessageSuccess(message: String) {
        print("My message: \(message)")
    }
    
    private func didMessageError(error: String) {
        print("My error: \(error)")
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
    
    @objc private func didTapOnLoginButtonAction(_ sender: SpotifyLoginButton) {
        // Test Only
        viewModel?.getLoginTest(message: "My app")
        viewModel?.getLoginTest()
        
        sender.startLoading()
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userTopRead]

        if #available(iOS 11, *) {
            Static.shared.sessionManager.initiateSession(with: scope, options: .clientOnly)
            
        } else {
            Static.shared.sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateLoginButtonWith(title: String) {
        let connectButtonWidth = Static.widthForViewLabel(text: title,
                                                          font: connectButton.titleLabel!.font,
                                                          height: connectButton.bounds.height) + (Static.margin32x * 3)
        
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

// MARK: - Spotify View State Delegate

extension LoginViewController: SpotifyViewStateDelegate {
    
    // Session Manager
    
    func spotifySessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        Static.shared.spotifyAPIToken = session.accessToken
        
        DispatchQueue.main.async {
            let homeVC = HomeBuilder.buildViewController()
            NavigationHandler.shared.checkAfterPushViewController(vcl: homeVC, classOf: HomeViewController.self, weakSelf: self)
        }
    }
    
    func spotifySessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    func spotifySessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Dismiss")
    }
    
    // Player State
    
    func update(playerState: SPTAppRemotePlayerState) {
        // Code
    }
    
    // App Remote
    
    func spotifyAppRemoteDidConnected() {
        let titleValue = NSLocalizedString("loginSuccessButtonTitle", comment: "").uppercased()
        let title = NSAttributedString(string: titleValue, attributes: connectButton.titleAttributes)
        
        DispatchQueue.main.async {
            self.connectButton.setAttributedTitle(title, for: .normal)
            self.updateLoginButtonWith(title: titleValue)
        }
    }
    
    func spotifyAppRemoteDidOffline() {
        let titleValue = NSLocalizedString("loginWaitingButtonTitle", comment: "").uppercased()
        let title = NSAttributedString(string: titleValue, attributes: connectButton.titleAttributes)
        
        DispatchQueue.main.async {
            self.connectButton.setAttributedTitle(title, for: .normal)
            self.updateLoginButtonWith(title: titleValue)
        }
    }
    
}
