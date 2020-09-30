//
//  LoginViewModelProtocol.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol {
    
    var didMessageSuccess: ((String) -> Void)? { get set }
    var didMessageError: ((String) -> Void)? { get set }
    
    func startInitialConfiguration()
    
    func getLoginTest()
    
    func getLoginTest(message: String)
    
}
