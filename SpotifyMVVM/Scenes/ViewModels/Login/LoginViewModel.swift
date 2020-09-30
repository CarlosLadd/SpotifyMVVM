//
//  LoginViewModel.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

final class LoginViewModel: LoginViewModelProtocol {
    
    var didMessageSuccess: ((String) -> Void)?
    var didMessageError: ((String) -> Void)?
    
    func startInitialConfiguration() {
        print(#function)
    }
    
    // MARK: - Message Action
    
    func getLoginTest(message: String) {
        var msgDefault = message
        
        if message.isEmpty {
            msgDefault = "Hello World"
        }
        
        self.processMessage(msg: msgDefault)
    }
    
    func getLoginTest() {
        self.processMessage(msg: "")
    }
    
    // MARK: - Process
    
    func processMessage(msg: String) {
        if msg.isEmpty {
            self.didMessageError?("The message not found")
            
        } else {
            self.didMessageSuccess?(msg)
        }
    }
    
}
