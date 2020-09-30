//
//  SpotifyViewStateDelegate.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/24/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

@objc protocol SpotifyViewStateDelegate {
    
    func spotifyAppRemoteDidConnected()
    
    func spotifyAppRemoteDidOffline()
    
    func update(playerState: SPTAppRemotePlayerState)
    
    func spotifySessionManager(manager: SPTSessionManager, didFailWith error: Error)
    
    func spotifySessionManager(manager: SPTSessionManager, didRenew session: SPTSession)
    
    func spotifySessionManager(manager: SPTSessionManager, didInitiate session: SPTSession)
    
}
